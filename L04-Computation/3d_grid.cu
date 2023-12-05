#include <stdio.h>
#include <cuda.h>

__global__ void dkernel() {
    // only one block with ID (0,0,0) and only one thread within a block with ID (0,0,0)
    if (threadIdx.x == 0 && blockIdx.x == 0 &&
        threadIdx.y == 0 && blockIdx.y == 0 &&
        threadIdx.z == 0 && blockIdx.z == 0) {
            printf("%d %d %d %d %d %d \n", gridDim.x, gridDim.y, gridDim.z, blockDim.x, blockDim.y, blockDim.z);
    }
}

int main() {
    dim3 grid(2,3,4);
    dim3 block(5,6,7);
    dkernel<<<grid, block>>>();
    // #threads = 2*3*4*5*6*7
    // #threads in a block = 5*6*7
    // #blocks in the grid for dkernel = 2*3*4
    cudaDeviceSynchronize();
    return 0;
}