# v4-march-native

| field | value |
|---|---|
| commit | `55c4ae0` |
| N | 1001 |
| threads | 4 |
| extra flags | `-march=native` |
| runs (s) | 81.811 78.897 81.258 |
| **median (s)** | **81.258** |
| sweeps | 136105 |
| output identical to baseline | yes |
| machine | 4 cores, Intel(R) Xeon(R) Silver 4216 CPU @ 2.10GHz |
| compiler | gcc (Ubuntu 15.2.0-16ubuntu1) 15.2.0 |

## perf stat (N=301)
```
 Performance counter stats for './sandpile.exe 301':
          3,165.42 msec task-clock                                                            
     8,277,365,921      cycles                                                                  (66.72%)
     9,153,911,677      instructions                                                            (83.35%)
     1,639,200,133      branches                                                                (83.32%)
       102,608,089      branch-misses                                                           (83.21%)
        23,932,335      cache-references                                                        (83.36%)
         1,008,600      cache-misses                                                            (83.40%)
       0.810857457 seconds time elapsed
       3.142017000 seconds user
       0.025016000 seconds sys
```

## hotspots (perf record, N=301)
```
    53.67%  sandpile.exe  sandpile.exe          [.] stabilize._omp_fn.0
    10.69%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c76
    10.25%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c72
     6.88%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c70
     4.07%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c7b
     3.23%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a82
     3.14%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a86
     2.94%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a80
     1.34%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a8b
     0.43%  sandpile.exe  [unknown]             [k] 0xffffffff8d8094fd
     0.32%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026a8f
     0.32%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026c7f
     0.17%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000026b4f
     0.17%  sandpile.exe  libgomp.so.1.0.0      [.] 0x0000000000023b3d
     0.12%  sandpile.exe  sandpile.exe          [.] stbi_zlib_compress
```
