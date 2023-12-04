#include <stdio.h>
#include <cuda.h>

__global__ void dkernel(char *arr, int arrlen) {
    unsigned id = threadIdx.x;
    if (id < arrlen) {
        ++arr[id];
    }
}

int main() {
    char cpuarr[] = "Gdn Vnc-";
    char *gpuarr;

    auto sz = sizeof(char) * (1 + strlen(cpuarr));

    cudaMalloc(&gpuarr, sz);
    cudaMemcpy(gpuarr, cpuarr, sz, cudaMemcpyHostToDevice);
    
    dkernel<<<1,strlen(cpuarr)>>>(gpuarr, strlen(cpuarr));
    
    cudaMemcpy(cpuarr, gpuarr, sz, cudaMemcpyDeviceToHost);
    printf(cpuarr);
    
    return 0;
}