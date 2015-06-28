// Jacobi 3D skeleton program
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "timing.h"

int main(int argc, char** argv) {

  double wct_start,wct_end,cput_start,cput_end,runtime,r;
  int iter,size,i,j,k,n;
  double *f1, *f2;

  iter = 1000;
  double mintime = 4.0;

  if (argc != 2 && argc != 3) {
    printf("Usage: %s <size> [mintime]\n",argv[0]);
    exit(1);
  }
  if (argc == 3) {
    mintime = atof(argv[2]);
  }

  size = atoi(argv[1]);
  f1 = malloc((size_t)size*sizeof(double));
  f2 = malloc((size_t)size*sizeof(double));

#pragma omp parallel for schedule(static)
  for (i = 0; i < size; i++) {
    f1[i] = sin( (double) i * i);
    f2[i] = cos( (double) 2*i);
  } 

  double sum = 0.0;

  while (1) {
    timing(&wct_start, &cput_start);
    for (j = 0; j < iter; j++) {
#pragma omp parallel for reduction(+:sum) schedule(static)
      for (i = 0; i < size; i++) {
        sum += f1[i]*f2[i];
      }
    }
    timing(&wct_end, &cput_end);
    // making sure mintime was spent, otherwise restart with 2*iter
    if (wct_end - wct_start > mintime) {
      break;
    }
    iter = iter * 2;
  }

  runtime = wct_end - wct_start;

  printf("size:\t%d\ttime/iter:\t%lf\tGFLOP/s:\t%lf\n", size, runtime/iter, ((double)iter) * size * 1e-9 / runtime);
  
  return 0;
}

