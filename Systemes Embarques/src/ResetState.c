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

void usage(char *);

void usage(char *szPgmName) {
    if(szPgmName == NULL) {
        exit(-1);
    }
    printf("%s <motor (L | R) >\n", szPgmName);
}

int main(int argc, char *argv[]) {

    int iAreaState;
    char idmotor;
    char StateMem[STR_LEN];
    double *var_state;

    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    /*        Verification des arguments        */
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    if( argc != 2)
    {
        usage(argv[0]);
        return( 0 );
    };

    if( sscanf(argv[1],"%c",&idmotor) == 0 )
    {
        fprintf(stderr,"%s.main()  : ERREUR ---> l'argument #1 doit etre un caractere\n", argv[0]);
        usage(argv[0]);
        return( 0 );
    };

    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/
    /*        Zones de memoires partagees       */
    /*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*/

    sprintf(StateMem, "COMMAND_%c", idmotor);

    if(( iAreaState = shm_open(StateMem, O_RDWR | O_CREAT, 0600)) < 0)
    {
        fprintf(stderr,"%s.main() :  ERREUR ---> appel a shm_open() #1\n", argv[0]);
        fprintf(stderr,"             code = %d (%s)\n", errno, (char *)(strerror(errno)));
        exit( -errno );
    }
    else
    {
        printf("LIEN a la zone %s\n", StateMem);
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

    memset(var_state,0, 2 * sizeof(double));
    return(0);
}