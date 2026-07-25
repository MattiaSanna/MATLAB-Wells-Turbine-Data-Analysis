# wells-turbine-MATLAB

MATLAB scripts used to process experimental data from the OWC (Oscillating Water Column) turbine simulator at DIMCM, University of Cagliari, for a thesis studying how blade **solidity** affects Wells turbine performance.

**Please note: for clear reazons I will not share the experimental data but only the scripts I personally coded.**


### Background

Key findings the scripts were built to produce:

- Maximum torque scales roughly proportionally with solidity.
- Efficiency stays fairly stable for the 4–6 blade configurations, then drops off at higher solidity — a clear trade-off between peak torque and peak efficiency.
- σ ≈ 0.625 comes out as the best overall compromise.
- A constant-solidity blade design was also compared against a conventional constant-chord design, reaching 70–75% efficiency vs. 50–55%, mainly from lower aerodynamic losses.

### What the scripts do

1. Load raw run data for each configuration from `Measurements/Z<n>/test.mat`.
2. Compute the flow rate from piston velocity and the non-dimensional flow coefficient φ from air velocity and rotor speed.
3. Zero out torque and ΔP samples outside the valid φ range (below-threshold values are noise, not real turbine operation).
4. Integrate instantaneous aerodynamic power and pneumatic power over time (`trapz`) to get the average efficiency for that run.
5. Plot efficiency and (manually recorded) max torque against solidity σ on a dual-axis chart.

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

### Usage

Run the script directly in MATLAB (adjust the loop range if you add/remove configurations):

```matlab
>> efficiency_vs_solidity
```

This produces a figure with efficiency and max torque plotted against σ, using the fixed `sigma` and manually-logged `max_torque` vectors at the top of the script.

### Note

This README is based on the one example script and the thesis context. If there are more scripts in the project (e.g. for the local/pointwise measurements, or the constant-chord vs. constant-solidity comparison), let me know and I'll fold them into this structure.
