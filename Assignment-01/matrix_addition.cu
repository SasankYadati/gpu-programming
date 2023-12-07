#include <iostream>
#include <cuda.h>
#include <kernels.h>
using namespace std;

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