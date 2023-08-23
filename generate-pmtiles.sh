#!/bin/bash

# ogr2ogr -f FlatGeobuf ./original//Rwasom\ 2\ Data/Bugesera\ Survey\ of\ Facility/ECD_Point.shp ECD_Point.shp ECD_Point

dir_path="./original/data"

find $dir_path -name '* *' | sed 's/ /_/g'

find $dir_path -name '* *' |\
while read line; do newline=$(echo $line | sed 's/ /_/g'); echo $newline; mv "$line" $newline; done

shps=`find $dir_path -maxdepth 2 -type f -name *.shp`

gpkg_dir="gpkg_data"
rm -rf $gpkg_dir
mkdir -p $gpkg_dir

for shp in $shps;
do
    fgb=`echo ${shp//.shp/.fgb}`
    file_ext=${shp##*/}
    # echo $file_ext
    layername=`echo ${file_ext//.shp/}`

    ogr2ogr -f GPKG -update -append $gpkg_dir/$layername.gpkg $shp -nln $layername
    ogr2ogr -f FlatGeobuf -skipfailures $fgb $shp $layername
done

gpkgs=`find $gpkg_dir -type f -name *.gpkg`
for gpkg in $gpkgs;
do
    file_ext=${gpkg##*/}
    # echo $file_ext
    layername=`echo ${file_ext//.gpkg/}`

    ogr2ogr -f GPKG -update -append wasac-rwasom-2-data.gpkg $gpkg -nln $layername
done

rm -rf $gpkg_dir

layers=("ECD_Point" "ECD" "Health_Facility_Point" "Health_Facility" "Office_point" "Office" "School_Point" "School")

for layer in "${layers[@]}"
do
    fgb_list=`find $dir_path -maxdepth 2 -type f -iname *$layer.fgb | perl -pe 's/\n/ /'`
    tippecanoe -Z7 -z15 -rg -ps -pS -pf -pk -P -l $layer -f -o $layer.pmtiles $fgb_list
done

tile-join -pk -pC -f \
-n "rwasom-phase2-data" \
-N "This dataset is to manage ECD (Early Childhood Development) center, health facilities, schools and government offices in Rwanda. The data was collected by WASAC, Ltd." \
-A "©<a href='https://wasac.rw'>WASAC,Ltd.</a>" \
-o wasac-rwasom-2-data.pmtiles \
ECD_Point.pmtiles \
ECD.pmtiles \
Health_Facility_Point.pmtiles \
Health_Facility.pmtiles \
Office_point.pmtiles \
Office.pmtiles \
School_Point.pmtiles \
School.pmtiles 

for layer in "${layers[@]}"
do
    rm $layer.pmtiles
done
