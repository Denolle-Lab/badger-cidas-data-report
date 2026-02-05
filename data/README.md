# Data Directory

This directory is for storing seismic data files from the BADGER-CIDAS experiment.

## Important Note

⚠️ Data files are **not tracked** in git due to their large size (see `.gitignore`).

Users should download or generate data separately and place it here.

## Supported Data Formats

### Seismic Formats
- **MiniSEED** (`.mseed`) - Standard seismic data format
- **SAC** (`.sac`) - Seismic Analysis Code format
- **SEED** (`.seed`) - Full SEED volumes

### DAS Formats
- **HDF5** (`.h5`, `.hdf5`) - Hierarchical data format for DAS arrays
- **NumPy** (`.npy`, `.npz`) - Preprocessed array data

## Directory Organization

Consider organizing data by:
- Date: `data/2024-01-15/`
- Station: `data/BB01/`, `data/DAS_fiber/`
- Event: `data/event_001/`

## Data Access

Contact the BADGER-CIDAS team for access to observational data from the field experiment.
