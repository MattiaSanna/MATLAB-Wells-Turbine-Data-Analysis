# wells-turbine-MATLAB


**Note: The experimental data used in the thesis cannot be shared publicly. The dataset included in this repository is a sampled and randomized version, provided only for demonstration and code reproducibility purposes. Full credit for planing, setting up and calibrating the testing environment goes to F. Licheri et al., as acknowledged in the thesis.**

MATLAB scripts used to process experimental data from the OWC (Oscillating Water Column) turbine simulator.


### Background

The thesis characterized the global performance of a Wells turbine under bidirectional airflow and involved building a MATLAB pipeline for signal processing, inertial mass calculations, and performance/loss analysis. Key findings:

- Maximum torque scales roughly proportionally with solidity.
- Efficiency stays fairly stable for the 4–6 blade configurations, then drops off at higher solidity — a clear trade-off between peak torque and peak efficiency.
- σ ≈ 0.625 comes out as the best overall compromise.
- Aerodynamic and kinetic losses show a quadratic correlation with solidity, offering practical guidance for Wells rotor design.
- A constant-solidity blade design was also compared against a conventional constant-chord design, reaching 70–75% efficiency vs. 50–55%, mainly from lower aerodynamic losses.
- A zero-crossing algorithm was implemented to determine the optimal number of periods to acquire per test, cutting processing time by 35–40%.

### What the scripts do

This repo covers the performance/efficiency/loss-analysis stage of the pipeline, plus the zero-crossing period-selection demo. Each script loads one or more `test.mat` files from `Measurements/Z<n>/` and shares its plot styling (colors, fonts) via `info.m`.

1. **`compTurbines.m`** — loops over all five blade counts (Z4–Z8). For each: computes the flow coefficient φ, torque coefficient T\*, pressure coefficient p\*, and instantaneous efficiency η; derives the mean blade-span velocity, relative/absolute velocity triangle components, and the velocity-reduction coefficients λ and ψ; from these, computes rotor (aerodynamic) losses ξ_R, exit losses ξ_exit, and total-to-static efficiency η_ts. Plots all six quantities against φ, overlaying all 5 blade counts on the same axes (6 figures total).

2. **`zero_crossing.m`** — loads a single raw (non pre-averaged) run (`Measurements/Z6/test_T7s_F70Hz_no-medie.mat`) and demonstrates the zero-crossing period-selection algorithm: detects cycle boundaries by finding where the piston position crosses a fixed threshold, resamples each detected cycle onto a uniform 1000-point grid, then averages the first *P* cycles for P = 1, 5, 7, 10, 15. Plots rotational speed, torque, ΔP, ambient-side pressure, and piston position vs. normalized cycle time for each P, to show how quickly the averaged waveform converges with more cycles.

3. **`angles.m`** — loops over Z4–Z8, computes the flow coefficient φ and the rotor exit relative-flow angle β₂ from the velocity triangle, then interpolates β₂ at a fixed design flow coefficient (φ = 0.15) for each turbine. Plots β₂ at that design point against solidity σ.

4. **`avgEfficency.m`** — loops over Z4–Z8, computes φ and zeroes out torque/ΔP samples outside a valid φ range (below-threshold values are noise, not real turbine operation), then integrates instantaneous aerodynamic power and pneumatic power over time (`trapz`) to get the average efficiency for that run. Plots efficiency and (manually recorded) max torque against solidity σ on a dual-axis chart.

5. **`compTurbine_Sigma_sqrt.m`** — loops over Z4–Z8, computes φ, T\*, and p\*, then divides T\* and p\* by σ² for each turbine. Plots the normalized torque and pressure coefficients against φ for all 5 blade counts overlaid, to check how well solidity-normalization collapses the curves.

6. **`turbinePlot.m`** — interactive version of script 1: prompts the user (`input`) to pick a single turbine (4, 5, 6, 7, or 8 blades), loads just that run, and computes/plots the same six quantities (T\*, p\*, η, ξ_R, ξ_exit, η_ts) vs. φ for that turbine alone.


7. **`inertia.m`** — calculation of the turbine inertia based on the measured torque and rotational frequency.




### Requirements

- MATLAB (base install — only `trapz` and standard plotting functions are used, no extra toolboxes).
- `info.m` on the path — defines shared plot styling (colors, font sizes) used by all figures.

### Project structure

```
.
├── info.m                       # shared plot styling (colors, fonts)
├── efficiency_vs_solidity.m      # loads test data, computes efficiency, plots vs. sigma
└── Measurements/
    ├── Z4/test.mat
    ├── Z5/test.mat
    ├── Z6/test.mat
    ├── Z7/test.mat
    └── Z8/test.mat
```

Each `test.mat` file contains a `test` struct with:

| Field | Description |
|---|---|
| `test.data(:,1)` | time |
| `test.data(:,3)` | piston velocity |
| `test.data(:,4)` | air velocity |
| `test.data(:,6)` | ΔP |
| `test.data(:,7)` | rotor speed [RPM] |
| `test.data(:,9)` | aerodynamic torque |
| `test.rho` | air density for that run |
