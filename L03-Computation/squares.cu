#include <stdio.h>
#include <cuda.h>
#define N 100

__global__ void dsq(int *a) {
    int i = threadIdx.x;
    a[i] = i*i;
}

int main() {
    int a[N], *da;
    
    cudaMalloc(&da, N * sizeof(int));
    
    dsq<<<1,N>>>(da);
    cudaMemcpy(a, da, N * sizeof(int), cudaMemcpyDeviceToHost);
    
    for (int i = 0; i < N; i++) {
        printf("%d\n", a[i]);
    }
    return 0;
}