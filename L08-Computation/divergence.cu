__global__ void dkernel(unsigned *vector, unsigned vectorsize) {
    unsigned id = blockIdx.x * blockDim.x + threadIdx.x;
    // thread divergence - different warp threads execute different instructions
    if (id % 2) { // odd no. threads
        vector[id] = id;
    }
    else { // even no. threads
        vector[id] = vectorsize * vectorsize;
    }
    vector[id]++;
}