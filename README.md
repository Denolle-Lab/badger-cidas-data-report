# BADGER CIDAS Data Report

This repository contains tutorials and scripts to plot seismic data from joint broadband and DAS (Distributed Acoustic Sensing) experiments. The tutorials demonstrate how to work with seismic data, metadata, and produce visualizations for data reports.

## Repository Structure

```
.
├── tutorials/
│   ├── python/          # Python tutorial scripts
│   ├── matlab/          # MATLAB tutorial scripts
│   └── notebooks/       # Jupyter notebooks
├── metadata/            # Metadata files for experiments
├── data/                # Sample data (not tracked in git)
├── environment.yml      # Conda environment file
└── pixi.toml           # Pixi project configuration
```

## Installation

### Using Conda

1. Install [Miniconda](https://docs.conda.io/en/latest/miniconda.html) or [Anaconda](https://www.anaconda.com/products/distribution)

2. Create the environment:
```bash
conda env create -f environment.yml
```

3. Activate the environment:
```bash
conda activate seismic-tutorials
```

### Using Pixi

[Pixi](https://prefix.dev/docs/pixi/overview) is a modern package manager for conda packages.

1. Install pixi:
```bash
curl -fsSL https://pixi.sh/install.sh | bash
```

2. Install dependencies:
```bash
pixi install
```

3. Run commands in the pixi environment:
```bash
pixi run jupyter
```

Or activate the shell:
```bash
pixi shell
```

## Dependencies

The following Python packages are included:

- **ObsPy**: Seismology library for processing seismic data
- **NumPy**: Numerical computing
- **Matplotlib**: Plotting and visualization
- **Pandas**: Data manipulation and analysis
- **Jupyter**: Interactive notebooks
- **SciPy**: Scientific computing
- **h5py**: HDF5 file format support

## Usage

### Python Scripts

Navigate to `tutorials/python/` and run any tutorial script:

```bash
python basic_seismic_plot.py
```

### MATLAB Scripts

Navigate to `tutorials/matlab/` and run scripts in MATLAB.

### Jupyter Notebooks

Start Jupyter notebook server:

```bash
# With conda
jupyter notebook

# With pixi
pixi run jupyter
```

Then navigate to `tutorials/notebooks/` in the browser interface.

## Tutorials

- **Python**: Basic seismic data plotting, DAS data visualization
- **MATLAB**: Seismic waveform analysis
- **Notebooks**: Interactive tutorials combining broadband and DAS data

## Data

Sample data files can be placed in the `data/` directory. Due to file size, data files are not tracked in git (see `.gitignore`).

Common seismic data formats supported:
- MiniSEED (`.mseed`)
- SAC (`.sac`)
- HDF5 (`.h5`, `.hdf5`)

## Metadata

Experiment metadata, station information, and instrument responses can be stored in the `metadata/` directory.

## Contributing

When adding new tutorials:

1. Place Python scripts in `tutorials/python/`
2. Place MATLAB scripts in `tutorials/matlab/`
3. Place Jupyter notebooks in `tutorials/notebooks/`
4. Include docstrings and comments
5. Add example outputs or figures when applicable

## License

See LICENSE file for details.

## Citation

If you use these tutorials or scripts in your research, please cite the associated data report.

## Contact

For questions or issues, please open an issue on GitHub.
