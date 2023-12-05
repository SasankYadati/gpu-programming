#include <stdio.h>
#include <cuda.h>

__global__ void init(int *da, int alen) {
    int i = threadIdx.x;
    if (i < alen) {
        da[i] = 0;
    }
}

__global__ void addIndex(int *da, int alen) {
    int i = threadIdx.x;
    if (i < alen) {
        da[i] += i;
    }
}

int main() {
    int *da;
    const int N = 8000;
    cudaMalloc(&da, N * sizeof(int));
    
    init<<<1,N>>>(da, N);
    addIndex<<<1,N>>>(da, N);
    cudaDeviceSynchronize();

    int a[N];
    cudaMemcpy(a, da, N*sizeof(int), cudaMemcpyDeviceToHost);

    for (int i=0; i<N; i++) {
        printf("%d ",a[i]);
    }

    return 0;
}