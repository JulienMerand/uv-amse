/* ############################## */
/*   Projet Systèmes Embarqués    */
/* UV AMSE - IMT Nord Europe 2023 */
/*         MÉRAND Julien          */
/* ############################## */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>
#include <fcntl.h>
#include <signal.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <stdbool.h>

#define STR_LEN 256

/*&&&&&&&&&&&&&&&&&&&&*/
/* Variables Globales */
/*&&&&&&&&&&&&&&&&&&&&*/
int GoOn = 1;
int iLoops = 0;
double *var_wL;
double *var_wR;
double *var_vel;
double te;
double r0;
double w;
/*&&&&&&&&&&&&&&&&&&&&*/
/*    Declarations    */
/*&&&&&&&&&&&&&&&&&&&&*/
void usage(char *);
void *Link2SharedMem(char *, int, int *, int);
void updateVelocity(void);
void SignalHandler(int);
/*&&&&&&&&&&&&&&&&&&&&*/
/*    Definitions     */
/*&&&&&&&&&&&&&&&&&&&&*/
void usage(char *szPgmName) {
    if(szPgmName == NULL) {
        exit(-1);
    }
    printf("%s <R0> <W> <D> <Periode d'ech.> <motor (L | R) >\n", szPgmName);
}
/* Creation ou Lien aux zones de memoire patagees */
void *Link2SharedMem(char *szAreaName, int iSize, int *iFd, int iCreate) {
    void *vAddr;

    if(szAreaName == NULL | iFd == NULL) {
        fprintf(stderr,"Link2SharedMem() : ERREUR ---> pointeur NULL passe en argument\n");
        return(NULL);
    };
    
    if((*iFd = shm_open(szAreaName, O_RDWR, 0600)) < 0) {
        if(iCreate > 0)
        {
            if((*iFd = shm_open(szAreaName, O_RDWR | O_CREAT, 0600)) < 0) {
                fprintf(stderr,"Link2SharedMem() :  ERREUR ---> appel a shm_open() pour creation \n");
                fprintf(stderr,"                    code = %d (%s)\n", errno, (char *)(strerror(errno)));
                return(NULL);
            };
        }
        else {
            fprintf(stderr,"Link2SharedMem() :  ERREUR ---> appel a shm_open() pour lien \n");
            fprintf(stderr,"                    code = %d (%s)\n", errno, (char *)(strerror(errno)));
            return(NULL);
        };
    };

    if(ftruncate(*iFd, iSize) < 0) {
        fprintf(stderr,"Link2SharedMem() :  ERREUR ---> appel a ftruncate() \n");
        fprintf(stderr,"                    code = %d (%s)\n", errno, (char *)(strerror(errno)));
        return( NULL );
    };

     if((vAddr = mmap(NULL, iSize, PROT_READ | PROT_WRITE, MAP_SHARED, *iFd, 0)) == MAP_FAILED) {
        fprintf(stderr,"Link2SharedMem() :  ERREUR ---> appel a mmap() #1\n");
        fprintf(stderr,"                    code = %d (%s)\n", errno, (char *)(strerror(errno)));
        return(NULL);
    };

    return(vAddr);
} 
/*&&&&&&&&&&&&&&&&&&&&*/
/*  Commande Moteur   */
/*&&&&&&&&&&&&&&&&&&&&*/
void updateVelocity(void) {
    double wL;
    double wR;
    double Vc;
    double Wc;

    wL = *var_wL;
    wR = *var_wR;
    
    Vc = 0.5 * r0 * (wL + wR);
    Wc = (r0/w) * (wR - wL);

    #if defined(USR_DBG)
    if((iLoops%5) == 0) {
        printf("Vc = %lf Wc = %lf \n", Vc, Wc);
    };
    iLoops++;
    #endif

    var_vel[0] = Vc;
    var_vel[1] = Wc;
}
/*&&&&&&&&&&&&&&&&&&&&*/
/*      Signal        */
/*&&&&&&&&&&&&&&&&&&&&*/
void SignalHandler(int signal) {
    if(signal == SIGALRM) {
        updateVelocity();
    }
}
/*&&&&&&&&&&&&&&&&&&&&*/
/*Programme principal */
/*&&&&&&&&&&&&&&&&&&&&*/
int main(int argc, char *argv[]) {
    int iAreaStateL;
    int iAreaStateR;
    int iAreaVelocity;
    double *var_stateL;
    double *var_stateR;

    struct sigaction sa;
    struct sigaction sa_old;
    sigset_t mask;
    struct itimerval sTime;
    int iLoops = 0;
    
    if(argc != 4) {
        usage(argv[0]);
        return(0);
    }

    if ((sscanf(argv[1], "%lf", &r0) == 0)
        || (sscanf(argv[2], "%lf", &w) == 0)
        || (sscanf(argv[3], "%lf", &te) == 0)) {
        fprintf(stderr, " main() : ERREUR ---> format des arguments incorrect \n");
        usage(argv[0]);
        return(0);
    }
    
    if((var_stateL = (double *)(Link2SharedMem("STATE_L", 2 * sizeof(double), &iAreaStateL, 1))) == NULL) {
        fprintf(stderr,"%s.main()  : ERREUR ---> appel a Link2SharedMem() #1\n", argv[0]);
        return(0);
    };
    if((var_stateR = (double *)(Link2SharedMem("STATE_R", 2 * sizeof(double), &iAreaStateR, 1))) == NULL) {
        fprintf(stderr,"%s.main()  : ERREUR ---> appel a Link2SharedMem() #2\n", argv[0]);
        return(0);
    };
    if((var_vel = (double *)(Link2SharedMem("VELOCITY", 2 * sizeof(double), &iAreaVelocity, 1 ))) == NULL) {
        fprintf(stderr,"%s.main()  : ERREUR ---> appel a Link2SharedMem() #3\n", argv[0]);
        return(0);
    };
    var_wL = &var_stateL[0];
    var_wR = &var_stateR[0];
    
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    /*          Routine d'interception          */
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
	memset( &sa, 0, sizeof( struct sigaction));
	sigemptyset( &mask );
	sa.sa_mask  = mask;
	sa.sa_handler =  SignalHandler;
	sa.sa_flags = 0;
    /* installation de la routine d'interception */
    if( sigaction(SIGALRM, &sa, &sa_old) < 0 )
    {
        fprintf(stderr,"%s.main() :  ERREUR ---> appel a sigaction() #1\n", argv[0]);
        fprintf(stderr,"             code = %d (%s)\n", errno, (char *)(strerror(errno)));
        exit( -errno );
    };

    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    /*          Configuration du timer          */
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    sTime.it_interval.tv_sec = (int)(te);
    sTime.it_interval.tv_usec = (int)((te - (int)(te))*1e6);
    sTime.it_value.tv_sec = (int)(te);
    sTime.it_value.tv_usec = (int)((te - (int)(te))*1e6);
    if( setitimer( ITIMER_REAL, &sTime, NULL) < 0 )
     {
        fprintf(stderr,"%s.main() :  ERREUR ---> appel a setitimer() \n", argv[0]);
        fprintf(stderr,"             code = %d (%s)\n", errno, (char *)(strerror(errno)));
        exit( -errno );
    };

    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    /*           Programme Principal            */
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    while(GoOn){
        pause();
        #if defined(USR_DBG)
        if(iLoops%5==0){
            printf("Vc = %lf | Wc = %lf\n", var_vel[0], var_vel[1]);
        }
        iLoops++;
        #endif
    }
    return(0);

}