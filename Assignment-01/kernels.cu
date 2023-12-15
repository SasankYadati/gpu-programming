#include "kernels.h"
#include <cuda.h>

__global__ void per_row_kernel(int m,int n,int *A,int *B,int *C) {
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    if (id < m) {
        for (int i=0; i<n; i++) {
            C[id * n + i] = A[id * n + i] + B[id * n + i];
        }
    }
}

__global__ void per_column_kernel(int m,int n,int *A,int *B,int *C) {
    int x = threadIdx.x;
    int y = threadIdx.y;
    int id = blockIdx.x * blockDim.x * blockDim.y + (x * blockDim.x + y);
    if (id < n) {
        for (int i=0; i<m; i++) {
            C[i * n + id] = A[i * n + id] + B[i * n + id];
        }
    }
}

__global__ void per_element_kernel(int m,int n,int *A,int *B,int *C) {
    int x = blockIdx.x;
    int y = blockIdx.y;
    int blockId = x * gridDim.x + y;
    int threadId = blockId * (blockDim.x * blockDim.y) + (threadIdx.x * blockDim.x + threadIdx.y);
    int id = threadId;
    if (id < m*n) {
        C[id] = A[id] + B[id];
    }
}
