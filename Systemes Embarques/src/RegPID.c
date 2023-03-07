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
double *var_u;
double *var_i;
double *var_w;
double *var_Tv;
double te;
double e;
double e_prev;
double De;
double Ie;
double Ie_prev;
double Kcoeff;
double Icoeff;
double Dcoeff;
/*&&&&&&&&&&&&&&&&&&&&*/
/*    Declarations    */
/*&&&&&&&&&&&&&&&&&&&&*/
void usage(char *);
void *Link2SharedMem(char *, int, int *, int);
void updateCommand(void);
void SignalHandler(int);
/*&&&&&&&&&&&&&&&&&&&&*/
/*    Definitions     */
/*&&&&&&&&&&&&&&&&&&&&*/
void usage(char *szPgmName) {
    if(szPgmName == NULL) {
        exit(-1);
    }
    printf("%s <P> <I> <D> <Periode d'ech.> <motor (L | R) >\n", szPgmName);
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
void updateCommand(void) {
    double u;
    double w;
    double Tv;
    double u_new;

    u = *var_u;
    w = *var_w;
    Tv = *var_Tv;

    e = Tv - w;
    De = (e - e_prev)/te;
    Ie = Ie_prev + te*e;
    u = Kcoeff*(e + Icoeff*Ie + Dcoeff*De);

    #if defined(USR_DBG)
    if((iLoops%5) == 0) {
        printf("Te = %lf e = %lf De = %lf Ie = %lf\n", te, e, De, Ie);
        printf("u PID = %lf\n", u);
    };
    iLoops++;
    #endif

    Ie_prev = Ie;
    e_prev = e;
    *var_u = u;
}
/*&&&&&&&&&&&&&&&&&&&&*/
/*      Signal        */
/*&&&&&&&&&&&&&&&&&&&&*/
void SignalHandler(int signal) {
    if(signal == SIGALRM) {
        updateCommand();
    }
}
/*&&&&&&&&&&&&&&&&&&&&*/
/*Programme principal */
/*&&&&&&&&&&&&&&&&&&&&*/
int main(int argc, char *argv[]) {
    int iAreaCmd;
    int iAreaState;
    int iAreaTarget;
    double r;
    double l;
    double ke;
    double km;
    double f;
    double j;
    double *var_state;
    char idmotor;
    char CommandMem[STR_LEN];
    char StateMem[STR_LEN];
    char TargetMem[STR_LEN];
    struct sigaction sa;
    struct sigaction sa_old;
    sigset_t mask;
    struct itimerval sTime;
    int iLoops = 0;
    
    if(argc != 6) {
        usage(argv[0]);
        return(0);
    }

    if ((sscanf(argv[1], "%lf", &Kcoeff) == 0)
        || (sscanf(argv[2], "%lf", &Icoeff) == 0)
        || (sscanf(argv[3], "%lf", &Dcoeff) == 0)
        || (sscanf(argv[4], "%lf", &te) == 0)
        || (sscanf(argv[5], "%c", &idmotor) == 0)) {
        fprintf(stderr, " main() : ERREUR ---> format des arguments incorrect \n");
        usage(argv[0]);
        return(0);
    }
    
    printf("Kcoeff : %lf | Icoeff : %lf | Dcoeff %lf\n", Kcoeff, Icoeff, Dcoeff);

    sprintf(CommandMem,"%s%c", "COMMAND_", idmotor);
    if((var_u = (double *)(Link2SharedMem(CommandMem, sizeof(double), &iAreaCmd, 1))) == NULL) {
        fprintf(stderr,"%s.main()  : ERREUR ---> appel a Link2SharedMem() #1\n", argv[0]);
        return(0);
    };
    sprintf(StateMem,"%s%c", "STATE_", idmotor);
    if((var_state = (double *)(Link2SharedMem(StateMem, 2 * sizeof(double), &iAreaState, 1))) == NULL) {
        fprintf(stderr,"%s.main()  : ERREUR ---> appel a Link2SharedMem() #2\n", argv[0]);
        return(0);
    };
    var_w = &var_state[0];
    var_i = &var_state[1];
    sprintf(TargetMem,"%s%c", "TARGET_", idmotor);
    if((var_Tv = (double *)(Link2SharedMem(TargetMem, sizeof(double), &iAreaTarget, 1 ))) == NULL) {
        fprintf(stderr,"%s.main()  : ERREUR ---> appel a Link2SharedMem() #3\n", argv[0]);
        return(0);
    };
    *var_Tv = 0.0;
    
    e = 0.0;
    e_prev = 0.0;
    Ie = 0.0;
    Ie_prev = 0.0;
    De = 0.0;

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
            printf("Tv = %lf | w = %lf\n", *var_Tv, *var_w);
        }
        iLoops++;
        #endif
    }
    return(0);

}































