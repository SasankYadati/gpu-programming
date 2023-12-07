#include<iostream>
#include<cuda.h>
#include <cmath>
#define BLOCK_SIZE 1024

using namespace std;

__global__ void dkernel(int *vectorX, int *vectorY, float *dist, int N) {
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    int id1, id2;
    id1 = id / N;
    id2 = id % N;
    float dist_;
    if (id<N*N) {
        auto x1 = vectorX[id1], y1 = vectorY[id1], x2 = vectorX[id2], y2 = vectorY[id2];
        dist_ = sqrt((float)(pow(x1 - x2, 2) + pow(y1 - y2, 2)));
        dist[id] = dist_;
    }
}

void readVectors(int *vec1, int *vec2, int count);


int main(int nn, char *str[]) {
    unsigned N = atoi(str[1]);
    unsigned nblocks = ceil((float)(N*N) / BLOCK_SIZE);

    dim3 blockdims(N,1);

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

    dkernel<<<nblocks,BLOCK_SIZE>>>(vectorX, vectorY, dist, N);
    cudaMemcpy(hdist, dist, N * N * sizeof(float), cudaMemcpyDeviceToHost);

    for (unsigned ii=0; ii<N; ii+=1) {
        for (unsigned jj=0; jj<N; jj+=1) {
            printf("%6.2f ", hdist[ii * N + jj]);
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