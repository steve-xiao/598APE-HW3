# v5-branchless

| field | value |
|---|---|
| commit | `e55b28c` |
| N | 1001 |
| threads | 4 |
| extra flags | `none` |
| runs (s) | 72.307 69.562 81.662 |
| **median (s)** | **72.307** |
| sweeps | 136105 |
| output identical to baseline | yes |
| machine | 4 cores, Intel(R) Xeon(R) Silver 4216 CPU @ 2.10GHz |
| compiler | gcc (Ubuntu 15.2.0-16ubuntu1) 15.2.0 |

## perf stat (N=301)
```
 Performance counter stats for './sandpile.exe 301':
          5,117.25 msec task-clock                                                            
    13,309,838,759      cycles                                                                  (66.68%)
    13,277,078,681      instructions                                                            (83.36%)
     1,600,082,032      branches                                                                (83.37%)
         5,669,548      branch-misses                                                           (83.25%)
        29,464,417      cache-references                                                        (83.31%)
         2,833,860      cache-misses                                                            (83.40%)
       1.521285035 seconds time elapsed
       5.045826000 seconds user
       0.072298000 seconds sys
```

## hotspots (perf record, N=301)
```
    41.16%  sandpile.exe  sandpile.exe          [.] stabilize._omp_fn.0
    11.68%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c72
    11.12%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c76
     7.80%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c70
     6.49%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a86
     6.46%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a82
     4.58%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c7b
     4.46%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a80
     2.43%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a8b
     0.31%  sandpile.exe  [unknown]             [k] 0xffffffff8d8094fd
     0.29%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a8f
     0.29%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c7f
     0.19%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000023b3d
     0.18%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026b4f
     0.14%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000023b70
```
