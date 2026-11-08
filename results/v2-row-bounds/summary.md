# v2-row-bounds

| field | value |
|---|---|
| commit | `f6f5f79` |
| N | 1001 |
| threads | 4 |
| extra flags | `none` |
| runs (s) | 315.402 |
| **median (s)** | **315.402** |
| sweeps | 166866 |
| output identical to baseline | yes |
| machine | 4 cores, Intel(R) Xeon(R) Silver 4216 CPU @ 2.10GHz |
| compiler | gcc (Ubuntu 15.2.0-16ubuntu1) 15.2.0 |

## perf stat (N=301)
```
 Performance counter stats for './sandpile.exe 301':
          2,810.10 msec task-clock                                                            
     7,373,892,456      cycles                                                                  (66.64%)
    11,266,566,683      instructions                                                            (83.33%)
     1,708,747,986      branches                                                                (83.35%)
       128,264,647      branch-misses                                                           (83.35%)
         5,748,393      cache-references                                                        (83.35%)
           977,974      cache-misses                                                            (83.31%)
       2.811697165 seconds time elapsed
       2.809242000 seconds user
       0.002000000 seconds sys
```

## hotspots (perf record, N=301)
```
    98.19%  sandpile.exe  sandpile.exe          [.] stabilize
     0.47%  sandpile.exe  [unknown]             [k] 0xffffffff8d8094fd
     0.24%  sandpile.exe  sandpile.exe          [.] stbi_zlib_compress
     0.09%  sandpile.exe  [unknown]             [k] 0xffffffff8d400ef0
     0.06%  sandpile.exe  [unknown]             [k] 0xffffffff8d8b8848
     0.05%  sandpile.exe  [unknown]             [k] 0xffffffff8eb0c7d4
     0.04%  sandpile.exe  [unknown]             [k] 0xffffffff8d976243
     0.03%  sandpile.exe  sandpile.exe          [.] stbiw__encode_png_line
     0.03%  sandpile.exe  [unknown]             [k] 0xffffffff8eb24a20
     0.03%  sandpile.exe  [unknown]             [k] 0xffffffff8d974d30
     0.02%  sandpile.exe  [unknown]             [k] 0xffffffff8d96df20
     0.02%  sandpile.exe  [unknown]             [k] 0xffffffff8d7eddcc
     0.02%  sandpile.exe  [unknown]             [k] 0xffffffff8d8dbb2d
     0.02%  sandpile.exe  [unknown]             [k] 0xffffffff8d8b9a65
     0.01%  sandpile.exe  [unknown]             [k] 0xffffffff8dc000bd
```
