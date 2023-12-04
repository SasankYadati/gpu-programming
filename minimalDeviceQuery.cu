#include <iostream>
#include <cuda_runtime.h>

int main() {
       int deviceCount;
       cudaError_t error_id = cudaGetDeviceCount(&deviceCount);
       if (error_id != cudaSuccess) {
              printf("cudaGetDeviceCount returned %d\n-> %s\n",
              static_cast<int>(error_id), cudaGetErrorString(error_id));
              printf("Result = FAIL\n");
              exit(EXIT_FAILURE);
       }
       if (deviceCount == 0) {
              printf("There are no available device(s) that support CUDA\n");
       } else {
              printf("Detected %d CUDA Capable device(s)\n", deviceCount);
       }

       for (int dev = 0; dev < deviceCount; ++dev) {
              cudaSetDevice(dev);
              cudaDeviceProp deviceProp;
              cudaGetDeviceProperties(&deviceProp, dev);

              printf("\nDevice %d: \"%s\"\n", dev, deviceProp.name);
              printf("  Total amount of constant memory:               %zu bytes\n", deviceProp.totalConstMem);
              printf("  GPU Max Clock rate:                            %0.2f GHz\n", deviceProp.clockRate * 1e-6f);
              printf("  Multiprocessors:                               %d Multiprocessors\n", deviceProp.multiProcessorCount);
              printf("  Maximum number of threads per multiprocessor:  %d\n", deviceProp.maxThreadsPerMultiProcessor);
        }
       return 0;
}