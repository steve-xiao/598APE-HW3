# v4-openmp

| field | value |
|---|---|
| commit | `6be13c1` |
| N | 1001 |
| threads | 4 |
| extra flags | `none` |
| runs (s) | 76.570 75.596 76.256 |
| **median (s)** | **76.256** |
| sweeps | 136105 |
| output identical to baseline | yes |
| machine | 4 cores, Intel(R) Xeon(R) Silver 4216 CPU @ 2.10GHz |
| compiler | gcc (Ubuntu 15.2.0-16ubuntu1) 15.2.0 |

## perf stat (N=301)
```
 Performance counter stats for './sandpile.exe 301':
          2,952.67 msec task-clock                                                            
     7,736,316,304      cycles                                                                  (66.66%)
     8,905,698,069      instructions                                                            (83.36%)
     1,614,842,991      branches                                                                (83.30%)
       103,700,797      branch-misses                                                           (83.25%)
        22,227,533      cache-references                                                        (83.37%)
           786,514      cache-misses                                                            (83.42%)
       1.702454428 seconds time elapsed
       2.930247000 seconds user
       0.023977000 seconds sys
```

## hotspots (perf record, N=301)
```
    39.59%  sandpile.exe  sandpile.exe          [.] stabilize._omp_fn.0
    12.34%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c72
    11.54%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c76
     8.33%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c70
     6.69%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a82
     6.48%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a86
     4.89%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a80
     4.53%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c7b
     2.31%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a8b
     0.35%  sandpile.exe  [unknown]             [k] 0xffffffff8d8094fd
     0.26%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c7f
     0.16%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000023b3d
     0.15%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a8f
     0.14%  sandpile.exe  sandpile.exe          [.] stbi_zlib_compress
     0.13%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026b4f
```
