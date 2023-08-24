# rwasom-phase-2-datasets

## pmtiles URL

```shell
https://wasac.github.io/rwasom-phase-2-datasets/data.pmtiles
```

## Pmtiles viewer

[Open this link](https://protomaps.github.io/PMTiles?url=https://wasac.github.io/rwasom-phase-2-datasets/data.pmtiles#map=8.96/-1.93/30.365)

## Generate pmtiles

Initially used `generate-pmtiles.sh` to convert original shapefiles to pmtiles and merged geopackage. Then WASAC renamed some field names to create `wasac-rwasom-2-data-revised.gpkg`. Final pmtiles was generated from this revised geopackage by using `generate-pmtiles-from-gpkg.sh`.

To use these script, the following software should be installed in the environment.

- tippecanoe
- gdal
