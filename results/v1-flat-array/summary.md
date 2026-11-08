# v1-flat-array

| field | value |
|---|---|
| commit | `974a8ff` |
| N | 1001 |
| threads | 4 |
| extra flags | `none` |
| runs (s) | 473.175 |
| **median (s)** | **473.175** |
| sweeps | 166866 |
| output identical to baseline | yes |
| machine | 4 cores, Intel(R) Xeon(R) Silver 4216 CPU @ 2.10GHz |
| compiler | gcc (Ubuntu 15.2.0-16ubuntu1) 15.2.0 |

## perf stat (N=301)
```
 Performance counter stats for './sandpile.exe 301':
          4,266.66 msec task-clock                                                            
    11,212,913,810      cycles                                                                  (66.64%)
    19,340,932,336      instructions                                                            (83.32%)
     3,026,786,532      branches                                                                (83.33%)
       128,933,926      branch-misses                                                           (83.35%)
         6,019,626      cache-references                                                        (83.33%)
         1,057,636      cache-misses                                                            (83.34%)
       4.269046326 seconds time elapsed
       4.262802000 seconds user
       0.004998000 seconds sys
```

## hotspots (perf record, N=301)
```
    92.62%  sandpile.exe  sandpile.exe          [.] stabilize
     1.66%  sandpile.exe  [unknown]             [k] 0xffffffff8d8094fd
     0.78%  sandpile.exe  [unknown]             [k] 0xffffffff8d400ef0
     0.22%  sandpile.exe  [unknown]             [k] 0xffffffff8d8b964c
     0.18%  sandpile.exe  [unknown]             [k] 0xffffffff8d8b8848
     0.14%  sandpile.exe  sandpile.exe          [.] stbi_zlib_compress
     0.11%  sandpile.exe  [unknown]             [k] 0xffffffff8d8d9bd0
     0.11%  sandpile.exe  [unknown]             [k] 0xffffffff8d7fa05b
     0.10%  sandpile.exe  [unknown]             [k] 0xffffffff8d8b9a65
     0.09%  sandpile.exe  [unknown]             [k] 0xffffffff8eb24a41
     0.09%  sandpile.exe  [unknown]             [k] 0xffffffff8d9be9b5
     0.08%  sandpile.exe  [unknown]             [k] 0xffffffff8d8dbb2d
     0.08%  sandpile.exe  [unknown]             [k] 0xffffffff8eb0c7d4
     0.07%  sandpile.exe  [unknown]             [k] 0xffffffff8eb24a20
     0.07%  sandpile.exe  [unknown]             [k] 0xffffffff8d8b967a
```
