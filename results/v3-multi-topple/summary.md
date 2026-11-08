# v3-multi-topple

| field | value |
|---|---|
| commit | `533b192` |
| N | 1001 |
| threads | 4 |
| extra flags | `none` |
| runs (s) | 248.182 |
| **median (s)** | **248.182** |
| sweeps | 136162 |
| output identical to baseline | yes |
| machine | 4 cores, Intel(R) Xeon(R) Silver 4216 CPU @ 2.10GHz |
| compiler | gcc (Ubuntu 15.2.0-16ubuntu1) 15.2.0 |

## perf stat (N=301)
```
 Performance counter stats for './sandpile.exe 301':
          2,277.61 msec task-clock                                                            
     5,901,127,608      cycles                                                                  (66.64%)
     8,252,113,975      instructions                                                            (83.30%)
     1,407,307,434      branches                                                                (83.35%)
       100,052,354      branch-misses                                                           (83.33%)
        10,135,627      cache-references                                                        (83.37%)
         1,356,895      cache-misses                                                            (83.31%)
       2.279414340 seconds time elapsed
       2.275791000 seconds user
       0.002999000 seconds sys
```

## hotspots (perf record, N=301)
```
    96.68%  sandpile.exe  sandpile.exe          [.] stabilize
     1.02%  sandpile.exe  [unknown]             [k] 0xffffffff8d8094fd
     0.23%  sandpile.exe  sandpile.exe          [.] stbi_zlib_compress
     0.22%  sandpile.exe  [unknown]             [k] 0xffffffff8d400ef0
     0.06%  sandpile.exe  [unknown]             [k] 0xffffffff8eb0c7d4
     0.05%  sandpile.exe  [unknown]             [k] 0xffffffff8d8b964c
     0.04%  sandpile.exe  [unknown]             [k] 0xffffffff8d8b967a
     0.04%  sandpile.exe  [unknown]             [k] 0xffffffff8d8aa532
     0.04%  sandpile.exe  [unknown]             [k] 0xffffffff8d7fa05b
     0.04%  sandpile.exe  [unknown]             [k] 0xffffffff8d8b8848
     0.03%  sandpile.exe  [unknown]             [k] 0xffffffff8db5fb25
     0.03%  sandpile.exe  [unknown]             [k] 0xffffffff8d9be9b5
     0.03%  sandpile.exe  [unknown]             [k] 0xffffffff8d7afa23
     0.03%  sandpile.exe  sandpile.exe          [.] stbiw__encode_png_line
     0.02%  sandpile.exe  [unknown]             [k] 0xffffffff8d7eddcc
```
