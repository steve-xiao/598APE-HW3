#!/usr/bin/env bash
# Thread-scaling experiment for the current sandpile.c.
# Usage: ./scaling.sh <label> [N] [runs]      e.g. ./scaling.sh v4-openmp 1001 1
# Produces rows labelled <label>-t1, <label>-t2, ... in results/results.csv
set -euo pipefail
LABEL=${1:?usage: ./scaling.sh <label> [N] [runs]}
N=${2:-1001}
RUNS=${3:-1}
MAX=$(nproc)
t=1
while [ "$t" -le "$MAX" ]; do
  OMP_NUM_THREADS=$t SKIP_PERF=1 ./bench.sh "$LABEL-t$t" "$N" "$RUNS"
  t=$((t * 2))
done
# also run at exactly nproc if it is not a power of two
if [ $((t / 2)) -ne "$MAX" ]; then
  OMP_NUM_THREADS=$MAX SKIP_PERF=1 ./bench.sh "$LABEL-t$MAX" "$N" "$RUNS"
fi
