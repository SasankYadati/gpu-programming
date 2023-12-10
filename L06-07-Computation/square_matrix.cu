#include<stdio.h>
#include<cuda.h>

void squarecpu(unsigned *matrix, unsigned *result, unsigned matrixsize) {
    for (unsigned ii=0; ii<matrixsize; ii++) {
        for (unsigned jj=0; jj<matrixsize; jj++) {
            for (unsigned kk=0; kk<matrixsize; kk++) {
                result[ii*matrixsize + jj] += matrix[ii * matrixsize + kk] * matrix[kk * matrixsize + jj];
            }
        }
    }
}

__global__ void squaregpu(unsigned *matrix, unsigned *result, unsigned matrixsize) {
    unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
    for (unsigned jj = 0; jj<matrixsize; jj++) {
        for (unsigned kk = 0; kk<matrixsize; kk++) {
            result[id*matrixsize+kk] += matrix[id * matrixsize + kk] * matrix[kk * matrixsize + jj];
        }
    }
}

__global__ void squaregpu2(unsigned *matrix, unsigned *result, unsigned matrixsize) {
    unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
    unsigned ii = id / matrixsize;
    unsigned jj = id % matrixsize;
    for (unsigned kk = 0; kk < matrixsize; kk++) {
        result[ii * matrixsize + jj] += matrix[ii * matrixsize + kk] * matrix[kk * matrixsize + jj];
    }
}

int main() {
    unsigned *matrix,*result;
    int matrixsize = 64;
    squaregpu<<<1,matrixsize>>>(matrix, result, matrixsize);
    squaregpu2<<<matrixsize, matrixsize>>>(matrix, result, matrixsize);
    cudaDeviceSynchronize();
    return 0;
}