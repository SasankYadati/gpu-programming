#include <iostream>
#include <cuda.h>

using namespace std;

__global__ void per_row_kernel() {
    //todo
}

__global__ void per_column_kernel() {
    //todo
}

__global__ void per_element_kernel() {
    //todo
}

int main() {
    int m,n;
    cin>>m>>n;
    int *matrixA, *matrixB;
    matrixA = (int*)(malloc(m*n*sizeof(int)));
    matrixB = (int*)(malloc(m*n*sizeof(int)));
    readMatrix(matrixA, m*n);
    readMatrix(matrixB, m*n);
    return 0;
}

void readMatrix(int *matrix, int count) {
    int elem;
    for (int i=0; i<count; i++) {
        cin>>elem;
        matrix[i] = elem;
    }
}