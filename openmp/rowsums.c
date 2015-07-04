// Jacobi 3D skeleton program
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "timing.h"

int main(int argc, char** argv) {

  double wct_start,wct_end,cput_start,cput_end,runtime,r;
  int iter,nrows,ncols,i,j,k,n, size;
  double *f1, *f2, *rsum, *rsumtrue;

  iter=50;
  double mintime = 4.0;

  if (argc != 3 && argc != 4) {
    printf("Usage: %s <nrows> <ncols> [mintime]\n",argv[0]);
    exit(1);
  }
  if (argc == 4) {
    mintime = atof(argv[3]);
  }

  nrows = atoi(argv[1]);
  ncols = atoi(argv[2]);
  size  = nrows * ncols;
  f1    = malloc((size_t)size*sizeof(double));
  rsum  = malloc((size_t)nrows*sizeof(double));
  rsumtrue = malloc((size_t)nrows*sizeof(double));


#pragma omp parallel for schedule(static)
  for (i = 0; i < size; i++) {
    f1[i] = sin( (double) i * i);
  } 

  for (i = 0; i < nrows; i++) {
    rsumtrue[i] = 0.0;
  }

  // for verification:
  for (i = 0; i < ncols; i++) {
    for (j = 0; j < nrows; j++) {
      rsumtrue[j] += f1[i*nrows + j];
    }
  }

  // time measurement
  timing(&wct_start, &cput_start);

  double my_rsum[nrows];

  while (1) {
    timing(&wct_start, &cput_start);
    for (j = 0; j < iter; j++) {
      for (i = 0; i < nrows; i++) {
        rsum[i] = 0.0;
      }
#pragma omp parallel private(my_rsum, i) shared(rsum)
{
      for (i = 0; i < nrows; i++) {
        my_rsum[i] = 0.0;
      }
#pragma omp for schedule(static)
      for (i = 0; i < size; i++) {
        my_rsum[i % nrows] += f1[i];
      }
#pragma omp critical
      for (i = 0; i < nrows; i++) {
        rsum[i] += my_rsum[i];
      }
} // end of #pragma omp parallel
    }
    timing(&wct_end, &cput_end);
    // making sure mintime was spent, otherwise restart with 2*iter
    if (wct_end - wct_start > mintime) {
      break;
    }
    iter = iter * 2;
  }

  timing(&wct_end, &cput_end);
  runtime = wct_end-wct_start;
    
  printf("size:\t%d\ttime/iter:\t%lf\tGFLOP/s:\t%lf\n", size, runtime/iter, ((double)iter) * size * 1e-9 / runtime);

  // verifying correctness of the computation
  for (i = 0; i < nrows; i++) {
    if (abs(rsum[i] - rsumtrue[i]) > 1e-5) {
      printf("Problem in %d-th row value\n", i);
      exit(1);
    }
  }
  
  return 0;
}

