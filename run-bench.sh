#!/bin/bash

## run all:
## ./run-bench.sh
## run only dot
## ./run-bench.sh -b dot

cpu_min=1
cpu_max=16
system_cores=`grep -c ^processor /proc/cpuinfo`
if [[ $cpu_max -gt $system_cores ]]; then
  cpu_max=$system_cores
fi

n=5000000
nrepeats=1
mintime=4 ## 4 seconds
benchmarks="sum dot normsq"
framework=""
output_dir=""

usage() { echo "Usage: $0 -f openmp|cilk [-b dot|normsq|sum] [-o ouput_dir] [-r num_repeats]" 1>&2; exit 1; }

while getopts ":b:f:o:r:" opt; do
  case $opt in
    b) benchmarks="$OPTARG" ;;
    f) framework="$OPTARG"  ;;
    o) output_dir="$OPTARG" ;;
    r) nrepeats="$OPTARG"   ;;
    \?) echo "Invalid option: -$OPTARG" >&2; usage;;
    :)  echo "Option -$OPTARG requires an argument." >&2; usage;;
    *)  usage;;
  esac
done

if [ -z "$framework" ]; then
  echo "Please choose parallel framework with '-f openmp' or '-f cilk'" >&2; usage
fi

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
  if [ -n "$output_dir" ]; then
    file=$output_dir/${bench}.${framework}.txt
    echo "Running '$bench' with $framework, results will be saved to '$file':"
    > $file
  else
    file=""
    echo "Running '$bench' with $framework, not saving results:"
  fi

  for repeat in `seq 1 $nrepeats`; do
    echo "Repeat $repeat / $nrepeats"
    for i in `seq $cpu_min $cpu_max`; do
      echo -n -e "$i\t"
      ## setting number of threads:
      declare -x $NTHREAD_VAR=$i
      $framework/$bench $n $mintime
    done | tee -a $file
  done

done

