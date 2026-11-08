#include <errno.h>
#include <inttypes.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

#define STB_IMAGE_WRITE_IMPLEMENTATION
#include "stb_image_write.h"

#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#define MAX(a, b) (((a) > (b)) ? (a) : (b))

static void die(const char *s) {
  fprintf(stderr, "%s\n", s);
  exit(1);
}

int N = 801;
int W;
int *cells;
int *row_lo;
int *row_hi;
long sweeps = 0;

#define grid(i, j) cells[((i) + 1) * W + (j) + 1]

// you can also use this function to debug print your sandpile
static void render(char *filename) {
  int chan = 3;
  unsigned char *pixels = (unsigned char *)malloc(N * N * chan * sizeof(char));
  int stride = N * chan;
  if (!pixels)
    die("malloc failed for PNG pixel buffer");
  for (int i = 0; i < N; ++i) {
    for (int j = 0; j < N; ++j) {
      unsigned char r = 0, g = 0, b = 0;
      switch (grid(i, j)) {
      case 0: // obsidian
        r = 15;
        g = 15;
        b = 25;
        break;
      case 1: // electric cyan
        r = 0;
        g = 210;
        b = 255;
        break;
      case 2: // vibrant magenta
        r = 230;
        g = 30;
        b = 130;
        break;
      case 3: // bright gold
        r = 255;
        g = 200;
        b = 0;
        break;
      default: // white
        r = 0;
        g = 0;
        b = 0;
      }

      int pid = (i * N + j) * chan;
      pixels[pid] = r;
      pixels[pid + 1] = g;
      pixels[pid + 2] = b;
    }
  }
  if (stbi_write_png(filename, N, N, chan, pixels, stride)) {
    printf("Successfully saved sandpile identity to: %s\n", filename);
  } else {
    die("Error: stb_image_write failed to save png file\n");
  }
  free(pixels);
}

static void compute_row_bounds() {
  for (int i = 0; i < N; ++i) {
    int lo = N, hi = -1;
    for (int j = 0; j <= MAX(i, N - 1 - i) && j < N; ++j) {
      if ((i - N / 2) * (i - N / 2) + (j - N / 2) * (j - N / 2) <=
          (N / 2) * (N / 2)) {
        if (j < lo)
          lo = j;
        hi = j;
      }
    }
    row_lo[i] = lo;
    row_hi[i] = hi;
  }
}

static void stabilize() {
  int *const g = cells;
  const int n = N, w = W;
#define G(i, j) g[((i) + 1) * w + (j) + 1]
  int changed = 0;
  do {
    changed = 0;
    sweeps++;
    for (int i = 0; i < n; ++i) {
      int *c = &G(i, 0), *up = &G(i - 1, 0), *dn = &G(i + 1, 0);
      const int lo = row_lo[i], hi = row_hi[i];
      for (int j = lo; j <= hi; ++j) {
        int q = c[j] >> 2;
        if (!q)
          continue;
        changed = 1;
        c[j] -= 4 * q;
        c[j - 1] += q;
        c[j + 1] += q;
        up[j] += q;
        dn[j] += q;
      }
    }
  } while (changed);
#undef G
}

void find_identity() {
  for (int i = 0; i < N; ++i) {
    for (int j = 0; j < N; ++j) {
      grid(i, j) = 6;
    }
  }
  stabilize();
  for (int i = 0; i < N; ++i) {
    for (int j = 0; j < N; ++j) {
      grid(i, j) = 6 - grid(i, j);
    }
  }
  stabilize();
}

int main(int argc, char **argv) {
  if (argc < 2 || argc > 2) {
    fprintf(stderr, "Usage: %s N\n", argv[0]);
    return EXIT_FAILURE;
  }
  char *end;
  uintmax_t parsed = strtoumax(argv[1], &end, 10);
  if (errno || argv[1][0] < '0' || argv[1][0] > '9' || *end || !parsed ||
      parsed > INT32_MAX)
    die("grid size must be a positive int");
  N = (int)parsed;

  W = N + 2;
  cells = (int *)calloc((size_t)W * W, sizeof(int));
  if (!cells)
    die("malloc failed for grid");
  row_lo = (int *)malloc(N * sizeof(int));
  row_hi = (int *)malloc(N * sizeof(int));
  if (!row_lo || !row_hi)
    die("malloc failed for row bounds");
  compute_row_bounds();

  find_identity();

  render("identity.png");
  fprintf(stderr, "sweeps: %ld\n", sweeps);
  free(cells);
  free(row_lo);
  free(row_hi);
  return EXIT_SUCCESS;
}
