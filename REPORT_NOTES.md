# Optimization notes (raw material for the report)

Fill the numbers in from `results/summary.md` after running the benchmarks on the VM.
Profile from the baseline: `stabilize` = ~98% of runtime (perf record, N=301), so
every optimization below targets `stabilize`.

---

## Opt 1: Flat, padded grid (data structure)
**Stage file:** `stages/v1_flat_array.c`

**What:** Replace `int **grid` (N separately-malloc'd rows) with one contiguous
`(N+2)x(N+2)` array. The extra 1-cell ring around the edge is a "sink": it
receives grains but is never toppled.

**Why it helps:**
- No pointer chase (`grid[i]` load) for every access; rows are adjacent in memory,
  so the `i-1` / `i+1` neighbours are at fixed offsets.
- The four bounds checks (`if (i > 0)`, `if (j > 0)`, ...) per topple disappear:
  edge grains just land in the sink ring, matching "grains that fall off disappear".

**Pitfall I hit (good introspection material):** the first version was *slower*
than the baseline (2.71s → 3.36s at N=301). The grid pointer and `N`/`W` were
globals; a store through `int *` may alias the global `int`s `N` and `W`, so the
compiler had to reload them from memory after every grain update. Copying them
into local `const` variables at the top of `stabilize` fixed it (→ 2.04s). Lesson:
a data-structure change only pays off once the compiler can prove the hot loop's
invariants don't change.

**Assumptions / scope:** none beyond the original program; works for any N.

---

## Opt 2: Precomputed per-row shape bounds (work reduction / loop-invariant hoisting)
**Stage file:** `stages/v2_row_bounds.c`

**What:** The original evaluates the circle test
`(i-N/2)^2 + (j-N/2)^2 <= (N/2)^2` and the mouth bound `j <= max(i, N-1-i)` for
every cell on every sweep, and also iterates over cells outside the circle. In each
row the pacman is one contiguous run of columns `[row_lo[i], row_hi[i]]`, so
compute those once (O(N^2) once, instead of O(N^2) per sweep) and loop only over
in-shape cells.

**Why it helps:** removes the multiply/compare and a hard-to-predict branch from
the inner loop and skips the ~21% of cells outside the circle (1 − π/4).

**Assumptions / scope:** the shape must be row-convex (one interval per row), which
holds for this pacman (circle ∩ half-plane-ish mouth). A non-convex shape would need
a list of intervals per row or a mask.

---

## Opt 3: Multi-topple (algorithmic)
**Stage file:** `stages/v3_multi_topple.c`

**What:** Instead of removing 4 grains once per visit (`if (g >= 4) g -= 4`),
topple `q = g / 4` (`g >> 2`) times at once: `g -= 4q`, each neighbour `+= q`.

**Why it is correct:** abelian property — the final stable sandpile (and the
number of grains that reach each sink cell) does not depend on toppling order or
grouping. Verified: output PNG is byte-identical to the baseline.

**Why it helps:** fewer sweeps over the grid are needed to converge (record the
`sweeps` column: e.g. 15,886 → 13,080 at N=301), and each visit does more work.

---

## Opt 4: Parallel 3-phase row sweeps with OpenMP (parallelism)
**Stage file:** `stages/v4_openmp.c` (Makefile needs `-fopenmp`)

**What:** Toppling cell (i, j) writes rows i−1, i, i+1. Two rows i and i+3 therefore
never write the same memory. Each sweep is split into 3 phases (rows ≡ 0, 1, 2 mod 3);
within a phase all rows run in parallel with `#pragma omp parallel for`, and the
`changed` flag is combined with `reduction(|:changed)`.

**Why it is correct:** no data races (disjoint writes within a phase) and the
abelian property makes the different update order irrelevant. Output identical.

**Results to report:** thread-scaling chart from `./scaling.sh`. Expect sub-linear
scaling: 3 barriers per sweep × ~100k+ sweeps at N=1001, and the loop is
memory-bound-ish.

---

## Tried, did not help
- **`-march=native`** (`EXTRA=-march=native ./bench.sh v4-march-native`): ~10%
  *slower* in my tests. The inner loop has a loop-carried dependency (cell j's
  topple adds to cell j+1, which is read next iteration), so it doesn't vectorize;
  wider instructions buy nothing.
- **Double-buffered (Jacobi) update** — every cell computes its new value from the
  previous sweep only (`new = g − 4·q(g) + Σ q(neighbours)`). Branch-free and
  vectorizable, but information only travels 1 cell per sweep instead of up to a
  whole row, so it needed far more sweeps: ~4m23s at N=1001 on 2 threads vs
  ~1m25s for the in-place version. Shows that sweep count, not per-sweep speed,
  dominates.

## Not implemented (future work)
- Active-region / worklist toppling: only revisit cells next to recent topples.
- Odometer estimation (least-action principle): predict how many times each cell
  topples, apply that in bulk, then finish with normal toppling. Could cut the
  sweep count dramatically, which is the remaining bottleneck (sweeps grow ~N²).
- Smaller cell type (`int16_t`) for better cache use — careful: sink cells
  accumulate large grain counts.
