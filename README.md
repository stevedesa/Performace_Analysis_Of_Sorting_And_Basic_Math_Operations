# Performance Analysis of Sorting and Basic Math Operations

## Project Overview
This project analyzes the performance of two programs (`qsort_small.c` and `basicmath_small.c`) under different optimization levels, cache configurations, and CPU architectures. The goal is to understand the impact of compiler optimizations, caching, and CPU design on execution time.

## Tasks
1. **Simulation of `qsort_small.c` with and without cache + optimization levels**
   - Compilation with `-O1`, `-O2`, `-O3` optimizations.
   - Execution with cached and non-cached configurations.
   - Results show significant performance improvements with caching, while compiler optimizations provide more modest gains.

2. **Simulation of `basicmath_small.c` with and without cache**
   - Testing on three CPU architectures: `ArmTimingSimpleCPU`, `ArmO3CPU`, `ArmMinorCPU`.
   - Results indicate that `ArmO3CPU` performs best due to out-of-order execution, and caching drastically reduces execution time.

3. **Rewriting `basicmath_small.c` in ARM RISC Assembly**
   - Comparison of C code vs. ARM assembly performance.
   - Assembly optimizations provide minor improvements for simpler CPUs, but advanced CPUs see little benefit from manual assembly coding.

## Key Findings
- **Caching** significantly reduces execution time, especially for memory-intensive tasks.
- **CPU architecture** is crucial, with out-of-order execution (`ArmO3CPU`) delivering the best performance.
- **Compiler optimizations** (`-O1`, `-O2`, `-O3`) provide diminishing returns beyond `-O1`.
- **Assembly-level optimizations** are more beneficial for simpler CPUs but offer limited gains for advanced CPUs with effective caching.

## Repository Structure
- **`qsort_small/`**: Contains the `qsort_small.c` program, input files, and simulation results.
- **`basicmath_small/`**: Contains the `basicmath_small.c` program, ARM assembly code, and simulation results.
- **`results/`**: Includes detailed execution time data and visual plots for each task.
