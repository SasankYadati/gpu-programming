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
    
    int *matrixA, *matrixB, *matrixC;
    cudaMalloc(&matrixA, m*n*sizeof(int));
    cudaMalloc(&matrixB, m*n*sizeof(int));
    cudaMalloc(&matrixC, m*n*sizeof(int));
    
    cudaMemcpy(matrixA, hmatrixA, m*n*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(matrixB, hmatrixB, m*n*sizeof(int), cudaMemcpyHostToDevice);

    int num_threads_per_block = m < BLOCKSIZE ? m : BLOCKSIZE;
    int num_blocks = ceil((float)m/BLOCKSIZE);

    per_row_kernel<<<num_blocks,num_threads_per_block>>>(m, n, matrixA, matrixB, matrixC);

    cudaMemcpy(hmatrixC, matrixC, m*n*sizeof(int), cudaMemcpyDeviceToHost);

    for (int i=0; i<m; i++) {
        for (int j=0; j<n; j++) {
            printf("%d ", hmatrixC[i * m + j]);
        }
        printf("\n");
    }

    num_threads_per_block = n < BLOCKSIZE ? n : BLOCKSIZE;
    dim3 blockDims(num_threads_per_block, num_threads_per_block);

    per_column_kernel<<<num_blocks, blockDims>>>(m, n, matrixA, matrixB, matrixC);
    
    return 0;
}

void readMatrix(int *matrix, int count) {
    int elem;
    for (int i=0; i<count; i++) {
        cin>>elem;
        matrix[i] = elem;
    }
}