#!/bin/bash

ord() { printf "%d" "'$1"; }

read -p "Entrez un QTH Locator : " LOC
LOC=$(echo "$LOC" | tr '[:lower:]' '[:upper:]')

export LC_NUMERIC=C

LON_D=$(echo "(($(ord ${LOC:0:1}) - 65) * 20 - 180 + (${LOC:2:1}) * 2 + ($(ord ${LOC:4:1}) - 65) * (2/24) + (1/24))" | bc -l)
LAT_D=$(echo "(($(ord ${LOC:1:1}) - 65) * 10 - 90 + (${LOC:3:1}) * 1 + ($(ord ${LOC:5:1}) - 65) * (1/24) + (0.5/24))" | bc -l)

convert_dmm() {
    local val=${1#-}
    local deg=$(echo "${val}/1" | bc)
    local min=$(echo "scale=2; ($val - $deg) * 60 / 1" | bc)
    printf "%02d.%05.2f" $deg $min
}

LAT_SVX=$(convert_dmm $LAT_D)
LON_SVX=$(convert_dmm $LON_D)

[[ $(echo "$LAT_D > 0" | bc -l) -eq 1 ]] && LAT_DIR="N" || LAT_DIR="S"
[[ $(echo "$LON_D > 0" | bc -l) -eq 1 ]] && LON_DIR="E" || LON_DIR="W"

FINAL_LAT="${LAT_SVX}${LAT_DIR}"
FINAL_LON="${LON_SVX}${LON_DIR}"

sed -i "s/^#LOCATION_INFO=LocationInfo/LOCATION_INFO=LocationInfo/" svxlink.conf
sed -i "s/LAT_POSITION=.*/LAT_POSITION=$FINAL_LAT/" svxlink.conf
sed -i "s/LONG_POSITION=.*/LONG_POSITION=$FINAL_LON/" svxlink.conf