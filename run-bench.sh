#!/bin/bash

## run all:
## ./run-bench.sh
## run only dot
## ./run-bench.sh -b dot

chip=E5-2699-v3
cpu_min=1
cpu_max=16
system_cores=`grep -c ^processor /proc/cpuinfo`
if [[ $cpu_max -gt $system_cores ]]; then
  cpu_max=$system_cores
fi

n=5000000
mintime=4 ## 4 seconds
benchmarks="sum dot normsq"
framework=openmp
no_output=1

while getopts ":b:f:o" opt; do
  case $opt in
    b)
      benchmarks="$OPTARG"
      ;;
    f)
      framework="$OPTARG"
      ;;
    o)
      no_output=0
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

if [[ "$framework" == "openmp" ]]; then
  NTHREAD_VAR=OMP_NUM_THREADS
elif [[ "$framework" == "cilk" ]]; then
  NTHREAD_VAR=CILK_NWORKERS
else
  echo "Unsupported framework '$framework'."
  exit 1
fi

for bench in $benchmarks
do
  if [[ $no_output -eq 0 ]]; then
    file=results/$chip/${bench}.${framework}.txt
    echo "Running '$bench' with $framework, results saved to $file:"
  else
    file=""
    echo "Running '$bench' with $framework, not saving results:"
  fi
  for i in `seq $cpu_min $cpu_max`; do
    echo -n -e "$i\t"
    ## setting number of threads:
    declare -x $NTHREAD_VAR=$i
    $framework/$bench $n $mintime
  done | tee $file
done

