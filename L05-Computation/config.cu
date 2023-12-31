#include<stdio.h>
#include<cuda.h>
#define BLOCKSIZE 1024

__global__ void dkernel(unsigned *matrix, int len) {
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    if (id < len) {
        matrix[id] = id;
    }
}

int main(int nn, char *str[]) {
    unsigned N = atoi(str[1]);
    unsigned *vector, *hvector;
    cudaMalloc(&vector, N * sizeof(unsigned));
    hvector = (unsigned *)(malloc(N*sizeof(int)));

    unsigned nblocks = ceil((float)N / BLOCKSIZE);
    printf("nblocks = %d\n", nblocks);

    dkernel<<<nblocks, BLOCKSIZE>>>(vector, N);
    cudaMemcpy(hvector, vector, N*sizeof(unsigned), cudaMemcpyDeviceToHost);
    for (unsigned ii=0; ii<N; ii++) {
        printf("%4d ", hvector[ii]);
    }
    return 0;
}