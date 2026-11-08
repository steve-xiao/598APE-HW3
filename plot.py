#!/usr/bin/env python3
"""Summarize results/results.csv into a table and charts for the report.

Usage: python3 plot.py [N]        (default N = largest N in the CSV)

Writes:
  results/summary.md         table: median time, speedup vs baseline / previous step
  results/speedup-<N>.png    bar chart of runtime per step (needs matplotlib)
  results/scaling-<N>.png    thread-scaling chart, if scaling.sh was run
"""
import csv
import re
import statistics
import sys
from collections import OrderedDict

rows = [r for r in csv.DictReader(open("results/results.csv"))]
if not rows:
    sys.exit("results/results.csv is empty")
N = sys.argv[1] if len(sys.argv) > 1 else max((r["N"] for r in rows), key=int)
rows = [r for r in rows if r["N"] == N]

scale_re = re.compile(r"^(.*)-t(\d+)$")
steps, scaling = OrderedDict(), OrderedDict()
for r in rows:
    m = scale_re.match(r["label"])
    target = scaling.setdefault(m.group(1), {}).setdefault(int(m.group(2)), []) if m \
        else steps.setdefault(r["label"], [])
    target.append(r)


def med(rs):
    return statistics.median(float(r["seconds"]) for r in rs)


# ---- table ----
lines = [f"# Results at N={N}", "",
         "| step | median time (s) | runs | speedup vs baseline | speedup vs previous | sweeps | threads | correct |",
         "|---|---|---|---|---|---|---|---|"]
base = prev = None
for label, rs in steps.items():
    t = med(rs)
    base = base or t
    vs_prev = f"{prev / t:.2f}x" if prev else "-"
    ok = "yes" if all(r["correct"] in ("yes", "ref-created") for r in rs) else "**NO**"
    lines.append(f"| {label} | {t:.2f} | {len(rs)} | {base / t:.2f}x | {vs_prev} | "
                 f"{rs[-1]['sweeps'] or 'n/a'} | {rs[-1]['threads']} | {ok} |")
    prev = t
if scaling:
    for label, by_t in scaling.items():
        lines += ["", f"## Thread scaling: {label}", "",
                  "| threads | median time (s) | speedup vs 1 thread | efficiency |", "|---|---|---|---|"]
        t1 = med(by_t[min(by_t)])
        for th in sorted(by_t):
            t = med(by_t[th])
            lines.append(f"| {th} | {t:.2f} | {t1 / t:.2f}x | {100 * t1 / t / th:.0f}% |")
open("results/summary.md", "w").write("\n".join(lines) + "\n")
print("\n".join(lines))
print("\nwrote results/summary.md")

# ---- charts ----
try:
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
except ImportError:
    sys.exit("matplotlib not installed (pip install --user matplotlib); table only.")

labels = list(steps)
times = [med(steps[l]) for l in labels]
fig, ax = plt.subplots(figsize=(7, 3.6))
bars = ax.bar(labels, times, color="#4C72B0")
for b, t in zip(bars, times):
    ax.annotate(f"{t:.1f}s\n{times[0] / t:.1f}x", (b.get_x() + b.get_width() / 2, t),
                ha="center", va="bottom", fontsize=8)
ax.set_ylabel("runtime (s)")
ax.set_title(f"Sandpile identity, N={N}: runtime per optimization step")
ax.set_ylim(0, max(times) * 1.25)
plt.xticks(rotation=20, ha="right", fontsize=8)
fig.tight_layout()
fig.savefig(f"results/speedup-{N}.png", dpi=200)
print(f"wrote results/speedup-{N}.png")

for label, by_t in scaling.items():
    th = sorted(by_t)
    t1 = med(by_t[th[0]])
    sp = [t1 / med(by_t[t]) for t in th]
    fig, ax = plt.subplots(figsize=(4.5, 3.4))
    ax.plot(th, sp, "o-", label="measured")
    ax.plot(th, th, "--", color="gray", label="ideal")
    ax.set_xlabel("threads")
    ax.set_ylabel("speedup vs 1 thread")
    ax.set_xticks(th)
    ax.set_title(f"{label} thread scaling, N={N}")
    ax.legend()
    fig.tight_layout()
    fig.savefig(f"results/scaling-{N}.png", dpi=200)
    print(f"wrote results/scaling-{N}.png")
