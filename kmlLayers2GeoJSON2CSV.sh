#!/bin/bash

# http://gis.stackexchange.com/questions/87218/converting-multilayer-kml-files-to-geojson-using-ogr2ogr
# https://alastaira.wordpress.com/2011/02/21/using-ogr2ogr-to-convert-reproject-and-load-spatial-data-to-sql-server/
# http://www.convertcsv.com/geojson-to-csv.htm
# http://stackoverflow.com/questions/24641948/merging-csv-files-appending-instead-of-merging

# you need to have the GDAL package installed, e.g. under the debian umbrella OSs: 
# $ apt-get install gdal-bin
#
# to check if that package is installed type:
# $ dpkg -l | grep gdal

# ATTENTION! If you download a KMZ archive from Google Maps you can treat it as a normal ZIP file
#            so you can unzip the KML file inside which usually is "doc.kml"
#            (unzip YOUR_ARCHIVE.kmz doc.kml) 
#            then use it as the input of this bash script
#
# ATTENTION! Assuming the layers in the KML file do not contain spaces (e.g. "bla_bla_foo_bar")

# TODO: for some reason ogr2ogr inverts X and Y, 
#       i.e. those coordinates on Google Maps show in the middle of nowhere
#       so it would be good to swap X and Y columns in the CSV
#       so then they could be easily used to search on Google Maps

if [ -z "$1" ]
 then
  echo You need to provide the KML file name as an input parameter!
  exit 1
fi

INPUT_KML_FILE=$1
INPUT_FILENAME_WITHOUT_EXTENSION="${INPUT_KML_FILE%.*}"
echo --- Processing input KML file ${INPUT_KML_FILE}

findLayers="$(ogrinfo -ro -so ${INPUT_KML_FILE} | tail -n+3 | cut -d ':' -f2 | awk '{print $1}')"
layers=$findLayers

for layer in $layers
do
  echo --- Layer: $layer
  ogr2ogr -f "GeoJSON" "file_${layer}.json" doc.kml "${layer}"
  echo '    Done with the GeoJSON'
  ogr2ogr -f "CSV" -lco "GEOMETRY=AS_XY" "file_${layer}.csv" "file_${layer}.json"
  echo '    Done with the CSV'
done
echo --- Done with all the layers! 


OUTPUT_FILE="${INPUT_FILENAME_WITHOUT_EXTENSION}.csv"  # Fix the output name
i=0                                                    # Reset a counter
for filename in ./*.csv; do 
 if [ "$filename"  != "$OUTPUT_FILE" ] ;               # Avoid recursion 
 then 
   if [[ $i -eq 0 ]] ; then
      # copying the column names with double quotes
      head -1  $filename | sed 's/^/"/g' | sed 's/,/","/g' | sed 's/$/"/g'  >   $OUTPUT_FILE  # Copy header if it is the first file
   fi
   tail -n +2  $filename >>  $OUTPUT_FILE              # Append from the 2nd line each file
   i=$(( $i + 1 ))                                     # Increase the counter
 fi
done
echo --- Done with appending all the CSV files into: ${OUTPUT_FILE}
