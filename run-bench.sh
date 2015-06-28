#!/bin/bash

## run all:
## ./run-bench.sh
## run only dot
## ./run-bench.sh -b dot

chip=E5-2699-v3
cpu_min=1
cpu_max=16

n=5000000
mintime=4 ## 4 seconds
benchmarks="sum dot normsq"

while getopts ":b:" opt; do
  case $opt in
    b)
      benchmarks="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

for bench in $benchmarks
do
  file=results/$chip/${bench}.openmp.txt
  echo "Writing into $file:"
  for i in `seq $cpu_min $cpu_max`; do echo -n -e "$i\t"; OMP_NUM_THREADS=$i openmp/$bench $n $mintime; done | tee $file
done

