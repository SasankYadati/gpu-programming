#include <iostream>
#include <cuda.h>
#include "kernels.h"
#define BLOCKSIZE 1024

using namespace std;

void readMatrix(int *matrix, int count);

int main() {
    int m,n;
    cin>>m>>n;
    int *hmatrixA, *hmatrixB, *hmatrixC;
    hmatrixA = (int*)(malloc(m*n*sizeof(int)));
    hmatrixB = (int*)(malloc(m*n*sizeof(int)));
    hmatrixC = (int*)(malloc(m*n*sizeof(int)));
    readMatrix(hmatrixA, m*n);
    readMatrix(hmatrixB, m*n);
    
    printf("--------------------\n");
    for (int i=0; i<m; i++) {
        for (int j=0; j<n; j++) {
            printf("%d ", hmatrixA[i * n + j]);
        }
        printf("\n");
    }

    printf("--------------------\n");
    for (int i=0; i<m; i++) {
        for (int j=0; j<n; j++) {
            printf("%d ", hmatrixA[i * n + j]);
        }
        printf("\n");
    }

    int *matrixA, *matrixB, *matrixC;
    cudaMalloc(&matrixA, m*n*sizeof(int));
    cudaMalloc(&matrixB, m*n*sizeof(int));
    cudaMalloc(&matrixC, m*n*sizeof(int));
    
    cudaMemcpy(matrixA, hmatrixA, m*n*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(matrixB, hmatrixB, m*n*sizeof(int), cudaMemcpyHostToDevice);

    int num_blocks = ceil((float)m/BLOCKSIZE);

    per_row_kernel<<<num_blocks,BLOCKSIZE>>>(m, n, matrixA, matrixB, matrixC);

    cudaMemcpy(hmatrixC, matrixC, m*n*sizeof(int), cudaMemcpyDeviceToHost);

    printf("--------------------\n");
    for (int i=0; i<m; i++) {
        for (int j=0; j<n; j++) {
            printf("%d ", hmatrixC[i * n + j]);
        }
        printf("\n");
    }


    num_blocks = ceil((float)n/(BLOCKSIZE*BLOCKSIZE));
    dim3 blockDims(BLOCKSIZE, BLOCKSIZE);

    per_column_kernel<<<num_blocks, blockDims>>>(m, n, matrixA, matrixB, matrixC);
    
    cudaMemcpy(hmatrixC, matrixC, m*n*sizeof(int), cudaMemcpyDeviceToHost);

    printf("--------------------\n");
    for (int i=0; i<m; i++) {
        for (int j=0; j<n; j++) {
            printf("%d ", hmatrixC[i * n + j]);
        }
        printf("\n");
    }

    num_blocks = ceil((float)(m*n)/(BLOCKSIZE*BLOCKSIZE));
    dim3 gridDims(num_blocks/2, num_blocks-(num_blocks/2)+1);

    per_element_kernel<<<gridDims, blockDims>>>(m, n, matrixA, matrixB, matrixC);

    cudaMemcpy(hmatrixC, matrixC, m*n*sizeof(int), cudaMemcpyDeviceToHost);

    printf("--------------------\n");
    for (int i=0; i<m; i++) {
        for (int j=0; j<n; j++) {
            printf("%d ", hmatrixC[i * n + j]);
        }
        printf("\n");
    }

    return 0;
}

void readMatrix(int *matrix, int count) {
    int elem;
    for (int i=0; i<count; i++) {
        cin>>elem;
        matrix[i] = elem;
    }
}