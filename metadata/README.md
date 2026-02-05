# Metadata

This directory contains metadata files for the BADGER-CIDAS experiment.

## Directory Structure

```
metadata/
├── stations/          # Station information and coordinates
├── responses/         # Instrument response files
├── timing/            # Timing and synchronization info
└── deployment/        # Deployment logs and notes
```

## Metadata Types

### Station Information
- Station locations (latitude, longitude, elevation)
- Instrument types and serial numbers
- Installation dates and configurations

### Instrument Responses
- Broadband seismometer response files
- DAS interrogator specifications
- Calibration information

### Timing
- Clock synchronization records
- GPS timing data
- Drift corrections

### Deployment
- Field notes and observations
- Site conditions
- Maintenance logs

## File Formats

Metadata files should use standard formats:
- CSV for tabular data
- JSON for structured metadata
- StationXML for seismic station information
- Plain text for notes and logs

## Usage

Reference metadata files in analysis scripts to ensure proper data interpretation.
