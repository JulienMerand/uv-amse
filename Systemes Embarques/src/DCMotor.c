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
bool state_DCMotor = true;
int GoOn = 1;
double coeffi1, coeffi2, coeffi3, coeffw1, coeffw2;

/* Variables partagees */
double *var_state;
double *var_u;
double *var_i;
double *var_w;

void usage(char *);
void SignalHandler(int);
void init(double, double, double, double, double, double, double);
void update(void);

void usage(char *szPgmName) {
    if(szPgmName == NULL) {
        exit(-1);
    }
    printf("%s <R> <L> <Ke> <Km> <f> <J> <Tm> <IDMotor>\n", szPgmName);
}

void init(double r, double l, double ke, double km, double f, double j, double te) {
    double z0, z1, b0, b1;

    z0 = exp(-te*r/l);
    z1 = exp(-te*f/j);
    b0 = (1-z0)/r;
    b1 = km*(1-z1)/f;

    coeffi1 = z0;
    coeffi2 = -ke*b0;
    coeffi3 = b0;
    coeffw1 = z1;
    coeffw2 = b1;
}

void reset(){
    coeffi1 = 0.0;
    coeffi2 = 0.0;
    coeffi3 = 0.0;
    coeffw1 = 0.0;
    coeffw2 = 0.0;
    *var_u = 0.0;
    *var_i = 0.0;
    *var_w = 0.0;
}

void update(void) {

    double u = *var_u;
    double i = *var_i;
    double w = *var_w;
    double i_new;
    double w_new;
    
    i_new = coeffi1*i + coeffi2*w + coeffi3*u;
    w_new = coeffw1*w + coeffw2*i;

    *var_i = i_new;
    *var_w = w_new;
}

void SignalHandler(int signal) {
    if(signal == SIGUSR1) {
        state_DCMotor = !state_DCMotor;
        if(state_DCMotor){
            printf("ON\n");
            GoOn = 1;
        }
        else{
            printf("Reset du modele...");
            reset();
            printf("OK\n");
            GoOn = 0;
        }  
    }
    if(signal == SIGALRM) {
        update();
    }
}

int main(int argc, char *argv[]) { 
    int iAreaCmd;
    int iAreaState;
    double r;
    double l;
    double ke;
    double km;
    double f;
    double j;
    double te;
    char idmotor;
    char CommandMem[STR_LEN];
    char StateMem[STR_LEN];
    struct sigaction sa;
    struct sigaction sa_old;
    sigset_t mask;
    struct itimerval sTime;
    int iLoops = 0;

    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    /*        Verification des arguments        */
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    if(argc != 9){
        usage(argv[0]);
        return(0);
    }
    if ((sscanf(argv[1], "%lf", &r) == 0)
        || (sscanf(argv[2], "%lf", &l) == 0)
        || (sscanf(argv[3], "%lf", &ke) == 0)
        || (sscanf(argv[4], "%lf", &km) == 0)
        || (sscanf(argv[5], "%lf", &f) == 0)
        || (sscanf(argv[6], "%lf", &j) == 0)
        || (sscanf(argv[7], "%lf", &te) == 0)
        || (sscanf(argv[8], "%c", &idmotor) == 0)) {
        fprintf(stderr, " main() : ERREUR ---> format des arguments incorrect \n");
        usage(argv[0]);
        return(0);
    }
    
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    /*    Initialisation de l'etat du moteur    */
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    init(r,l,ke,km,f,j,te);

    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    /* Creation des zones de memoires partagees */
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    sprintf(CommandMem, "STATE_%c", idmotor);
    sprintf(StateMem, "COMMAND_%c", idmotor);

    /* CommandMem */
    if(( iAreaCmd = shm_open(CommandMem, O_RDWR, 0600)) < 0) {
        if(( iAreaCmd = shm_open(CommandMem, O_RDWR | O_CREAT, 0600)) < 0)
        {
            fprintf(stderr,"%s.main() :  ERREUR ---> appel a shm_open() #1\n", argv[0]);
            fprintf(stderr,"             code = %d (%s)\n", errno, (char *)(strerror(errno)));
            exit( -errno );
        }
        else
        {
            printf("CREATION de la zone %s\n", CommandMem);
        };
    }
    else
    {
        printf("LIEN à la zone %s\n", CommandMem);
    };

    if( ftruncate(iAreaCmd, sizeof(double)) < 0 )
    {
        fprintf(stderr,"%s.main() :  ERREUR ---> appel a ftruncate() #1\n", argv[0]);
        fprintf(stderr,"             code = %d (%s)\n", errno, (char *)(strerror(errno)));
        exit( -errno );
    };

    if((var_u = (double *)(mmap(NULL, sizeof(double), PROT_READ | PROT_WRITE, MAP_SHARED, iAreaCmd, 0))) == MAP_FAILED )
    {
        fprintf(stderr,"%s.main() :  ERREUR ---> appel a mmap() #1\n", argv[0]);
        fprintf(stderr,"             code = %d (%s)\n", errno, (char *)(strerror(errno)));
        exit( -errno );
    };

    /* StateMem */
    if(( iAreaState = shm_open(StateMem, O_RDWR, 0600)) < 0) {
        if(( iAreaState = shm_open(StateMem, O_RDWR | O_CREAT, 0600)) < 0)
        {
            fprintf(stderr,"%s.main() :  ERREUR ---> appel a shm_open() #1\n", argv[0]);
            fprintf(stderr,"             code = %d (%s)\n", errno, (char *)(strerror(errno)));
            exit( -errno );
        }
        else
        {
            printf("CREATION de la zone %s\n", StateMem);
        };
    }
    else
    {
        printf("LIEN à la zone %s\n", StateMem);
    };

    if( ftruncate(iAreaState, 2 * sizeof(double)) < 0)
    {
        fprintf(stderr,"%s.main() :  ERREUR ---> appel a ftruncate() #1\n", argv[0]);
        fprintf(stderr,"             code = %d (%s)\n", errno, (char *)(strerror(errno)));
        exit( -errno );
    };

    if((var_state = (double *)(mmap(NULL, 2 * sizeof(double), PROT_READ | PROT_WRITE, MAP_SHARED, iAreaState, 0))) == MAP_FAILED )
    {
        fprintf(stderr,"%s.main() :  ERREUR ---> appel a mmap() #1\n", argv[0]);
        fprintf(stderr,"             code = %d (%s)\n", errno, (char *)(strerror(errno)));
        exit( -errno );
    };
    var_i = &var_state[0];
    var_w = &var_state[1];

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
    if( sigaction(SIGUSR1, &sa, &sa_old) < 0 )
    {
        fprintf(stderr,"%s.main() :  ERREUR ---> appel a sigaction() #2\n", argv[0]);
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
        if(iLoops%50==0){
            printf("u = %lf | w = %lf | i = %lf\n", *var_u, *var_w, *var_i);
        }
        iLoops++;
    }
    return(0);
}