# wells-turbine-MATLAB

MATLAB scripts used to process experimental data from the OWC (Oscillating Water Column) turbine simulator.

**Note: The experimental data used in the thesis cannot be shared publicly. The dataset included in this repository is a sampled and randomized version, provided only for demonstration and code reproducibility purposes. Full credit for setting up the testing environment goes to F. Licheri et al., as acknowledged in the thesis.**

### Background

The thesis characterized the global performance of a Wells turbine under bidirectional airflow and involved building a MATLAB pipeline for signal processing, inertial mass calculations, and performance/loss analysis. Key findings:

- Maximum torque scales roughly proportionally with solidity.
- Efficiency stays fairly stable for the 4–6 blade configurations, then drops off at higher solidity — a clear trade-off between peak torque and peak efficiency.
- σ ≈ 0.625 comes out as the best overall compromise.
- Aerodynamic and kinetic losses show a quadratic correlation with solidity, offering practical guidance for Wells rotor design.
- A constant-solidity blade design was also compared against a conventional constant-chord design, reaching 70–75% efficiency vs. 50–55%, mainly from lower aerodynamic losses.
- A zero-crossing algorithm was implemented to determine the optimal number of periods to acquire per test, cutting processing time by 35–40%.

### What the scripts do

This repo currently covers the performance/efficiency analysis stage of the pipeline:

1. Load raw run data for each configuration from `Measurements/Z<n>/test.mat`.
2. Compute the flow rate from piston velocity and the non-dimensional flow coefficient φ from air velocity and rotor speed.
3. Zero out torque and ΔP samples outside the valid φ range (below-threshold values are noise, not real turbine operation).
4. Integrate instantaneous aerodynamic power and pneumatic power over time (`trapz`) to get the average efficiency for that run.
5. Plot efficiency and (manually recorded) max torque against solidity σ on a dual-axis chart.

Other stages of the pipeline — signal processing, the zero-crossing period-selection algorithm, inertial mass calculations, and the aerodynamic/kinetic loss analysis — aren't included in this snippet yet.

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
