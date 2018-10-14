#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include "mkl_lapacke.h"

double *generate_matrix(int size) {
    int i;
    double *matrix = (double *)malloc(sizeof(double) * size * size);
    
    srand(1);

    for (i = 0; i < size * size; i++)
    {
        matrix[i] = rand() % 100;
    }

    return matrix;
}

void print_matrix(const char *name, double *matrix, int size) {
    int i, j;
    printf("matrix: %s \n", name);

    for (i = 0; i < size; i++)
    {
            for (j = 0; j < size; j++)
            {
                printf("%.3lf ", matrix[i * size + j]);
            }
            printf("\n");
    }
}

int check_result(double *bref, double *b, int size) {
    int i;
    for(i=0;i<size*size;i++) {
        if (abs(bref[i] - b[i]) > 0.00001) {
		return 0;
	}
    }
    return 1;
}


int my_dgesv(int n, int nrhs, double *a, int lda, int *ipiv, double *b, int ldb) {
	int i,j,k;
    double aux;


    //clear left side
    for (i = 0; i < n; i++) {
        for (j = 0; j < i; j++) {

            aux = a[i * n + j];

            for (k = 0; k < n; k ++) {
                a[i * n + k] = a[i * n + k] / aux - a[j * n + k];
                b[i * n + k] = b[i * n + k] / aux - b[j * n + k];
            }
        }

        aux = a[i * n + i];

        for (j = i; j < n; j++) {
            a[i * n + j] /= aux;
            b[i * n + j] /= aux;
        }

    }

      //clear right side
    for (i = n - 2; i >= 0; i--) {
        for (j = n - 1; j > i; j--) {
            aux = a[i * n + j];

            for (k = 0; k < n; k ++) {
                a[i * n + k] = a[i * n + k] / aux - a[j * n + k];
                b[i * n + k] = b[i * n + k] / aux - b[j * n + k];
            }
        }

        aux = a[i * n + i];

        for (j = i; j < n; j++) {
            a[i * n + j] /= aux;
            b[i * n + j] /= aux;
        }
    }    
}


int main(int argc, char **argv) {

        int size = atoi(argv[1]);

        double *a, *aref;
        double *b, *bref;

        srand(1);

        a = generate_matrix(size);
        aref = generate_matrix(size);        
        b = generate_matrix(size);
        bref = generate_matrix(size);
        
        // Using MKL to solve the system
        MKL_INT n = size, nrhs = size, lda = size, ldb = size, info;

        MKL_INT *ipiv = (MKL_INT *)malloc(sizeof(MKL_INT)*size);
        MKL_INT *ipiv2 = (MKL_INT *)malloc(sizeof(MKL_INT)*size);   

        clock_t tStart = clock();
        info = LAPACKE_dgesv(LAPACK_ROW_MAJOR, n, nrhs, aref, lda, ipiv, bref, ldb);
        printf("%.4fs\n", (double)(clock() - tStart) / CLOCKS_PER_SEC);

        tStart = clock();    
        my_dgesv(n, nrhs, a, lda, ipiv2, b, ldb);
        printf("%.4fs\n", (double)(clock() - tStart) / CLOCKS_PER_SEC);

        if (check_result(bref,b,size)==1)
            printf("ok\n");
        else    
            printf("error\n");
        
        free(a);
        free(b);
        free(aref);
        free(bref);

        free(ipiv);
        free(ipiv2);

        return 0;
    }
