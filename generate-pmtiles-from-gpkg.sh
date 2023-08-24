#!/bin/bash

fgbdir="./fgb"
gpkg="wasac-rwasom-2-data-revised.gpkg"

rm -rf $fgbdir
mkdir -p $fgbdir

layers=("ECD_Point" "ECD" "Health_Facility_Point" "Health_Facility" "Office_point" "Office" "School_Point" "School")

for layer in "${layers[@]}"
do
    layer=`echo $layer | tr '[:upper:]' '[:lower:]'`
    fgb="${fgbdir}/${layer}.fgb"
    ogr2ogr -f FlatGeobuf -skipfailures $fgb $gpkg $layer

    pmtiles="${fgbdir}/${layer}.pmtiles"

    minzoom="-Z11"
    if [[ "$layer" == *point* ]]; then
        minzoom="-Z7"
    fi

    tippecanoe $minzoom -z15 -rg -ps -pS -pf -pk -P -l $layer --use-attribute-for-id="id" -f -o $pmtiles $fgb
done

tile-join -pk -pC -f \
-n "rwasom-phase2-data" \
-N "This dataset is to manage ECD (Early Childhood Development) center, health facilities, schools and government offices in Rwanda. The data was collected by WASAC, Ltd." \
-A "©<a href='https://wasac.rw'>WASAC,Ltd.</a>" \
-o wasac-rwasom-2-data-revised.pmtiles \
"${fgbdir}/ECD_Point.pmtiles" \
"${fgbdir}/ECD.pmtiles" \
"${fgbdir}/Health_Facility_Point.pmtiles" \
"${fgbdir}/Health_Facility.pmtiles" \
"${fgbdir}/Office_point.pmtiles" \
"${fgbdir}/Office.pmtiles" \
"${fgbdir}/School_Point.pmtiles" \
"${fgbdir}/School.pmtiles" 

rm -rf $fgbdir
