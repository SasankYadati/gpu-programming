#include<iostream>
#include<cuda.h>
#include <cmath>
#define BLOCKSIZE 1024

using namespace std;

int getNumBlocks(dim3 gridDim) {
    return gridDim.x * gridDim.y * gridDim.z;
}

int getNumThreadsPerBlock(dim3 blockDim) {
    return blockDim.x * blockDim.y * blockDim.z;
}

__global__ void dkernel(int *vectorX, int *vectorY, float *dist, int N) {
    int id1 = threadIdx.x, id2 = threadIdx.y;
    id1 += blockDim.x * blockIdx.x;
    id2 += blockDim.y * blockIdx.y;
    if (id1<id2) {
        auto x1 = vectorX[id1], y1 = vectorY[id1], x2 = vectorX[id2], y2 = vectorY[id2];
        dist[id1 * blockDim.x + id2] = sqrt((float)(pow(x1 - x2, 2) + pow(y1 - y2, 2)));
        dist[id2 * blockDim.x + id1] = dist[id1 * blockDim.x + id2];
    }
}

void readVectors(int *vec1, int *vec2, int count);


int main(int nn, char *str[]) {
    unsigned N = atoi(str[1]);

    int nthreads = N * N;
    int nthreads_per_block_x =  nthreads < BLOCKSIZE ? N : BLOCKSIZE;
    int nthreads_per_block_y = nthreads_per_block_x;

    dim3 blockdims(nthreads_per_block_x,nthreads_per_block_y,1);
    unsigned nblocks = ceil((float)(nthreads) / (nthreads_per_block_x * nthreads_per_block_y));
    printf("nblocks = %d\n nthreads=%d\n blockdims=(%d, %d)\n", nblocks, nthreads, nthreads_per_block_x, nthreads_per_block_y);

    int *vectorX, *vectorY, *hvectorX, *hvectorY;
    
    cudaMalloc(&vectorX, N * sizeof(int));
    cudaMalloc(&vectorY, N * sizeof(int));
    hvectorX = (int *)(malloc(N*sizeof(int)));
    hvectorY = (int *)(malloc(N*sizeof(int)));
    
    readVectors(hvectorX, hvectorY, N);
    cudaMemcpy(vectorX, hvectorX, N*sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(vectorY, hvectorY, N*sizeof(int), cudaMemcpyHostToDevice);

    float *dist, *hdist;
    cudaMalloc(&dist, N * N * sizeof(float));
    hdist = (float *)(malloc(N * N * sizeof(float)));

    dkernel<<<nblocks,blockdims>>>(vectorX, vectorY, dist, N);
    cudaMemcpy(hdist, dist, N * N * sizeof(float), cudaMemcpyDeviceToHost);

    for (unsigned ii=0; ii<N; ii++) {
        for (unsigned jj=0; jj<N; jj++) {
            printf("%5.2f ", hdist[ii * N + jj]);
        }
        printf("\n");
    }

    return 0;
}

void readVectors(int *vec1, int *vec2, int count) {
    int x,y;
    for (int i=0; i<count; i++) {
        cin>>x>>y;;
        vec1[i] = x;
        vec2[i] = y;
    }
}