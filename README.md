# parallel-benchmark
Benchmarking parallel shared memory frameworks *OpenMP* and *CILK*.

Following micro-benchmarks are implemented:
* *dot* - scalar product of two vectors
* *normsq* - L2 norm squared of a vector
* *sum* - element-wise sum of two vectors

## Setup
* System: Dual Intel Xeon E5-2699-v3 node.
* OS: Ubuntu 14.04.2 LTS
* Compiler: Intel icc 14
* Compiler options:
  * OpenMP: `-O3 -xHost -fno-alias -fno-inline`
  * CILK: `-O3 -xHost -fno-alias`
* Each benchmark was iterated 1000 times for one run.
* If a run took less than 4 seconds, its number of iterations was doubled, until reaching 4 seconds.
* Results below are from 5 repeated runs (their *mean* and *standard deviation*).

## Compiling and running
```bash
make
./run-bench.sh -f openmp
./run-bench.sh -f cilk
```

## Dot results
```c
// openmp implementation:
double sum = 0.0;
#pragma omp parallel for reduction(+:sum) schedule(static)
for (i = 0; i < size; i++) {
  sum += f1[i]*f2[i];
}
```
<img src="https://raw.githubusercontent.com/jaak-s/parallel-benchmark/master/results/E5-2699-v3-5x/dot.gflops.png" width="480">

## Normsq results
```c
double sum = 0.0;
#pragma omp parallel for reduction(+:sum) schedule(static)
for (i = 0; i < size; i++) {
  sum += f1[i]*f1[i];
}
```
<img src="https://raw.githubusercontent.com/jaak-s/parallel-benchmark/master/results/E5-2699-v3-5x/normsq.gflops.png" width="480">

## Sum results
```c
#pragma omp parallel for schedule(static)
for (i = 0; i < size; i++) {
  f1[i] += f2[i];
}
```
<img src="https://raw.githubusercontent.com/jaak-s/parallel-benchmark/master/results/E5-2699-v3-5x/sum.gflops.png" width="480">

