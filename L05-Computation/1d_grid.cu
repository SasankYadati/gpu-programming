#include<stdio.h>
#include<cuda.h>
#define N 5
#define M 6

__global__ void dkernel(unsigned *matrix) {
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    matrix[id] = id;
}

int main() {
    unsigned *matrix, *hmatrix;
    cudaMalloc(&matrix, N*M*sizeof(unsigned));
    hmatrix = (unsigned *)(malloc(N*M*sizeof(unsigned)));

    dkernel<<<N,M>>>(matrix);
    cudaMemcpy(hmatrix, matrix, N*M*sizeof(unsigned), cudaMemcpyDeviceToHost);

    for (unsigned ii=0; ii<N; ii++) {
        for (unsigned jj=0; jj<M; jj++) {
            printf("%2d ", hmatrix[ii * M + jj]);
        }
        printf("\n");
    }

    return 0;    
}