# parallel-benchmark
Benchmarking parallel shared memory frameworks *OpenMP* and *CILK*.

Following micro-benchmarks are implemented:
* *dot* - scalar product of two vectors
* *normsq* - L2 norm squared of a vector
* *sum* - element-wise sum of two vectors

## Setup
* System: Dual Intel Xeon E5-2699-v3 node.
* Compiler: Intel icc 14
* Compiler options:
  * OpenMP: `-O3 -xHost -fno-alias -fno-inline`
  * CILK: `-O3 -xHost -fno-alias`

    Note: `fno-alias` was removed because it reduced CILK performance significantly

* Each benchmark was iterated 1000 times for one run.
* If a run took less 4 seconds, it was re-run with double number of iterations, until 4 seconds was reached.
* Each run was repeated 5 times.

## Dot results
<img src="https://raw.githubusercontent.com/jaak-s/parallel-benchmark/master/results/E5-2699-v3-5x/dot.gflops.png" width="480">

## Normsq results
<img src="https://raw.githubusercontent.com/jaak-s/parallel-benchmark/master/results/E5-2699-v3-5x/normsq.gflops.png" width="480">

## Sum results
<img src="https://raw.githubusercontent.com/jaak-s/parallel-benchmark/master/results/E5-2699-v3-5x/sum.gflops.png" width="480">

