#!/usr/bin/env bash
# Benchmark the current sandpile.c and write a per-step report.
#
# Usage:   ./bench.sh <label> [N] [runs]
# Example: ./bench.sh v0-baseline 1001 1
#
# Env vars:
#   OMP_NUM_THREADS  threads to use (default: all cores)
#   EXTRA            extra compiler flags, e.g. EXTRA=-march=native
#   PERF_N           grid size used for perf profiling (default 301, fast)
#   SKIP_PERF=1      skip the perf stat / perf record step
#
# Outputs:
#   results/results.csv           one row per timed run (all steps)
#   results/<label>/summary.md    human-readable report for this step
#   results/<label>/perf-stat.txt perf counters (cycles, instructions, ...)
#   results/<label>/hotspots.txt  top functions from perf record
#   refs/identity-<N>.png         reference image (created by the baseline)
set -euo pipefail

LABEL=${1:?usage: ./bench.sh <label> [N] [runs]}
N=${2:-1001}
RUNS=${3:-1}
PERF_N=${PERF_N:-301}
export OMP_NUM_THREADS=${OMP_NUM_THREADS:-$(nproc)}
EXTRA=${EXTRA:-}

OUT=results/$LABEL
mkdir -p "$OUT" refs
CSV=results/results.csv
[ -f "$CSV" ] || echo "label,commit,N,threads,extra,run,seconds,sweeps,correct,date" > "$CSV"

COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo nogit)
if ! git diff --quiet HEAD -- sandpile.c Makefile 2>/dev/null; then COMMIT="$COMMIT-dirty"; fi

echo "== building ($LABEL, EXTRA='$EXTRA')"
make clean >/dev/null
make all EXTRA="$EXTRA"

REF=refs/identity-$N.png
if [ ! -f "$REF" ] && [[ "$LABEL" != *baseline* ]]; then
  echo "ERROR: no reference image $REF. Benchmark the baseline at N=$N first." >&2
  exit 1
fi

TIMES=()
SWEEPS=""
ALL_OK=yes
for r in $(seq 1 "$RUNS"); do
  echo "== run $r/$RUNS: N=$N threads=$OMP_NUM_THREADS"
  start=$(date +%s.%N)
  ./sandpile.exe "$N" >/dev/null 2>"$OUT/stderr.txt"
  end=$(date +%s.%N)
  secs=$(awk -v a="$start" -v b="$end" 'BEGIN{printf "%.3f", b-a}')
  SWEEPS=$(awk '/^sweeps:/{print $2}' "$OUT/stderr.txt")
  if [ ! -f "$REF" ]; then
    cp identity.png "$REF"; ok=ref-created
  elif cmp -s identity.png "$REF"; then
    ok=yes
  else
    ok=NO; ALL_OK=NO
  fi
  echo "   ${secs}s  correct=$ok  sweeps=${SWEEPS:-n/a}"
  echo "$LABEL,$COMMIT,$N,$OMP_NUM_THREADS,$EXTRA,$r,$secs,$SWEEPS,$ok,$(date -Iseconds)" >> "$CSV"
  TIMES+=("$secs")
done
cp identity.png "$OUT/identity-$N.png"

MEDIAN=$(printf '%s\n' "${TIMES[@]}" | sort -n | awk '{a[NR]=$1} END{print (NR%2)?a[(NR+1)/2]:(a[NR/2]+a[NR/2+1])/2}')

# ---- profiling (at a smaller N so it stays fast) ----
PERF_NOTE="skipped"
if [ "${SKIP_PERF:-0}" != 1 ] && command -v perf >/dev/null; then
  echo "== perf at N=$PERF_N"
  if perf stat -e task-clock,cycles,instructions,branches,branch-misses,cache-references,cache-misses \
       -o "$OUT/perf-stat.txt" ./sandpile.exe "$PERF_N" >/dev/null 2>&1; then
    PERF_NOTE="N=$PERF_N"
  fi
  if perf record -q -g -o "$OUT/perf.data" ./sandpile.exe "$PERF_N" >/dev/null 2>&1 ||
     perf record -q -e cpu-clock -g -o "$OUT/perf.data" ./sandpile.exe "$PERF_N" >/dev/null 2>&1; then
    perf report -i "$OUT/perf.data" --stdio --no-children 2>/dev/null |
      grep -E '^ +[0-9.]+%' | head -15 > "$OUT/hotspots.txt" || true
  fi
fi

# ---- per-step report ----
{
  echo "# $LABEL"
  echo
  echo "| field | value |"
  echo "|---|---|"
  echo "| commit | \`$COMMIT\` |"
  echo "| N | $N |"
  echo "| threads | $OMP_NUM_THREADS |"
  echo "| extra flags | \`${EXTRA:-none}\` |"
  echo "| runs (s) | ${TIMES[*]} |"
  echo "| **median (s)** | **$MEDIAN** |"
  echo "| sweeps | ${SWEEPS:-n/a (baseline has no counter)} |"
  echo "| output identical to baseline | $ALL_OK |"
  echo "| machine | $(nproc) cores, $(grep -m1 'model name' /proc/cpuinfo | cut -d: -f2- | xargs) |"
  echo "| compiler | $(gcc --version | head -1) |"
  echo
  echo "## perf stat ($PERF_NOTE)"
  echo '```'
  if [ -f "$OUT/perf-stat.txt" ]; then grep -vE '^#|^$' "$OUT/perf-stat.txt"; else echo "n/a"; fi
  echo '```'
  echo
  echo "## hotspots (perf record, $PERF_NOTE)"
  echo '```'
  if [ -s "$OUT/hotspots.txt" ]; then cat "$OUT/hotspots.txt"; else echo "n/a"; fi
  echo '```'
} > "$OUT/summary.md"

echo "== median ${MEDIAN}s, correct=$ALL_OK  ->  $OUT/summary.md"
[ "$ALL_OK" = NO ] && { echo "WARNING: output differs from baseline!" >&2; exit 2; }
exit 0
