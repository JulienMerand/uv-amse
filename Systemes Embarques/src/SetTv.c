/* ############################## */
/*   Projet Systèmes Embarqués    */
/* UV AMSE - IMT Nord Europe 2023 */
/*         MÉRAND Julien          */
/* ############################## */

#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <signal.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/types.h> 
#include <sys/time.h>  
#include <ctype.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>

#define STR_LEN 256

double *var_Tv;

void usage(char *);

void usage(char *szPgmName) {
    if(szPgmName == NULL) {
        exit(-1);
    }
    printf("%s <value> <motor (L | R) >\n", szPgmName);
}

int main(int argc, char *argv[]) {
    
    char TargetMem[STR_LEN];
    int iAreaTarget;
    double Tv;
    char idmotor;

    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    /*        Verification des arguments        */
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    if(argc != 3){
        usage(argv[0]);
        return(0);
    }
    if ((sscanf(argv[1], "%lf", &Tv) == 0) || (sscanf(argv[2], "%c", &idmotor) == 0)) {
        fprintf(stderr, " main() : ERREUR ---> format des arguments incorrect \n");
        usage(argv[0]);
        return(0);
    }
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    /*        Zones de memoires partagees       */
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    sprintf(TargetMem, "TARGET_%c", idmotor);

    if(( iAreaTarget = shm_open(TargetMem, O_RDWR, 0600)) < 0) {
        fprintf(stderr,"%s.main() :  ERREUR ---> appel a shm_open() #1\n", argv[0]);
        fprintf(stderr,"             code = %d (%s)\n", errno, (char *)(strerror(errno)));
        exit( -errno );
    } else {
        printf("LIEN a la zone %s\n", TargetMem);
    };

    if( ftruncate(iAreaTarget, sizeof(double)) < 0 )
    {
        fprintf(stderr,"%s.main() :  ERREUR ---> appel a ftruncate() #1\n", argv[0]);
        fprintf(stderr,"             code = %d (%s)\n", errno, (char *)(strerror(errno)));
        exit( -errno );
    };

    if((var_Tv = (double *)(mmap(NULL, sizeof(double), PROT_READ | PROT_WRITE, MAP_SHARED, iAreaTarget, 0))) == MAP_FAILED )
    {
        fprintf(stderr,"%s.main() :  ERREUR ---> appel a mmap() #1\n", argv[0]);
        fprintf(stderr,"             code = %d (%s)\n", errno, (char *)(strerror(errno)));
        exit( -errno );
    };

    *var_Tv = Tv;
    return(0);

}