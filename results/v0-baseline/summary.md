# v0-baseline

| field | value |
|---|---|
| commit | `58be83c` |
| N | 1001 |
| threads | 4 |
| extra flags | `none` |
| runs (s) | 641.458 |
| **median (s)** | **641.458** |
| sweeps | n/a (baseline has no counter) |
| output identical to baseline | yes |
| machine | 4 cores, Intel(R) Xeon(R) Silver 4216 CPU @ 2.10GHz |
| compiler | gcc (Ubuntu 15.2.0-16ubuntu1) 15.2.0 |

## perf stat (N=301)
```
 Performance counter stats for './sandpile.exe 301':
          5,600.44 msec task-clock                                                            
    14,726,542,701      cycles                                                                  (66.65%)
    36,746,043,645      instructions                                                            (83.32%)
     4,138,981,604      branches                                                                (83.33%)
       133,793,094      branch-misses                                                           (83.34%)
         5,854,001      cache-references                                                        (83.35%)
         1,166,375      cache-misses                                                            (83.34%)
       5.602464196 seconds time elapsed
       5.599385000 seconds user
       0.001999000 seconds sys
```

## hotspots (perf record, N=301)
```
    98.59%  sandpile.exe  sandpile.exe          [.] stabilize
     0.54%  sandpile.exe  [unknown]             [k] 0xffffffff8d8094fd
     0.10%  sandpile.exe  sandpile.exe          [.] stbi_zlib_compress
     0.07%  sandpile.exe  [unknown]             [k] 0xffffffff8d400ef0
     0.03%  sandpile.exe  [unknown]             [k] 0xffffffff8d8b8848
     0.03%  sandpile.exe  [unknown]             [k] 0xffffffff8eb0c7d4
     0.02%  sandpile.exe  [unknown]             [k] 0xffffffff8d8b964c
     0.02%  sandpile.exe  [unknown]             [k] 0xffffffff8d7eddd1
     0.02%  sandpile.exe  [unknown]             [k] 0xffffffff8db5fb25
     0.02%  sandpile.exe  [unknown]             [k] 0xffffffff8d8d9be3
     0.01%  sandpile.exe  sandpile.exe          [.] stbiw__encode_png_line
     0.01%  sandpile.exe  [unknown]             [k] 0xffffffff8d8c308b
     0.01%  sandpile.exe  [unknown]             [k] 0xffffffff8d8b8854
     0.01%  sandpile.exe  [unknown]             [k] 0xffffffff8d97c74a
     0.01%  sandpile.exe  [unknown]             [k] 0xffffffff8d7afa23
```
