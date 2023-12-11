#include "kernels.h"
#include <cuda.h>

__global__ void per_row_kernel(int m,int n,int *A,int *B,int *C) {
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    for (int i=0; i<n; i++) {
        C[id * m + i] = A[id * m + i] + B[id * m + i];
    }
}

__global__ void per_column_kernel(int m,int n,int *A,int *B,int *C) {

}

__global__ void per_element_kernel(int m,int n,int *A,int *B,int *C) {
    
}
