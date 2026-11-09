# Results at N=1001

| step | median time (s) | runs | speedup vs baseline | speedup vs previous | sweeps | threads | correct |
|---|---|---|---|---|---|---|---|
| v0-baseline | 641.46 | 1 | 1.00x | - | n/a | 4 | yes |
| v1-flat-array | 473.18 | 1 | 1.36x | 1.36x | 166866 | 4 | yes |
| v2-row-bounds | 315.40 | 1 | 2.03x | 1.50x | 166866 | 4 | yes |
| v3-multi-topple | 248.18 | 1 | 2.58x | 1.27x | 136162 | 4 | yes |
| v4-openmp | 75.69 | 6 | 8.48x | 3.28x | 136105 | 4 | yes |
| v4-march-native | 81.26 | 3 | 7.89x | 0.93x | 136105 | 4 | yes |
| v5-branchless | 72.31 | 3 | 8.87x | 1.12x | 136105 | 4 | yes |

## Thread scaling: v4-openmp

| threads | median time (s) | speedup vs 1 thread | efficiency |
|---|---|---|---|
| 1 | 250.29 | 1.00x | 100% |
| 2 | 129.60 | 1.93x | 97% |
| 4 | 78.20 | 3.20x | 80% |
