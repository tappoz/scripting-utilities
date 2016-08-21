#!/usr/bin/env python2.7

# GDAL/OGR setup
# ==============
#
# On debian/ubuntu, check these packages are installed (`dpkg -s <PACKAGE_NAME>`), otherwise:
# ```
# $ sudo apt-get update
# $ sudo apt-get install libgdal1h
# $ sudo apt-get install libgdal1-dev
# ```
# 
# then check everything is all right:
# ```
# $ gdal-config --version
# 1.10.1
# ```
# 
# then install the `gdal` python package:
# ```
# $ sudo pip install --global-option=build_ext --global-option="-I/usr/include/gdal" GDAL==`gdal-config --version`
# [...]
# No matching distribution found for GDAL==1.10.1
# ```
# 
# alternatively:
# ```
# $ sudo pip install pygdal==`gdal-config --version`
# [...]
# Collecting pygdal==1.10.1
# [...]
# Successfully installed pygdal-1.10.1.0
# ```
# https://github.com/dezhin/pygdal
#
# It seems that both python packages `gdal` and `pygdal` have the same API calls.
# In my case the python `gdal` version is too recent for the debian/ubuntu GDAL C++ library, so the binding does not work.
#
# Docs: http://gdal.org/python/

# References
# ----------
#
# http://stackoverflow.com/questions/11336153/python-gdal-package-missing-header-file-when-installing-via-pip
# http://gis.stackexchange.com/questions/28966/python-gdal-package-missing-header-file-when-installing-via-pip
# https://gist.github.com/arthur-e/7d721f34e2536203513d
# https://gist.github.com/cspanring/5680334
# http://unix.stackexchange.com/questions/184310/installing-gdal-python-package-inside-python27-software-collection
# http://stackoverflow.com/questions/32066828/install-gdal-in-virtualenvwrapper-environment

'''
$ ./kmlLayers2GeoJSON2CSV.py -h
usage: kmlLayers2GeoJSON2CSV.py [-h] --kml-path KML_PATH --csv-path CSV_PATH

Processing a KML file to extract POIs into a CSV output

optional arguments:
  -h, --help           show this help message and exit
  --kml-path KML_PATH  full path to the KML input file to process, e.g.
                       '/home/USER/input_file.kml'
  --csv-path CSV_PATH  full path to the CSV output file, e.g.
                       '/home/USER/output_file.csv'
'''

from osgeo import ogr
ogr.UseExceptions()
import csv
import codecs
from argparse import ArgumentParser

def parse_input_parameters():
  description = 'Processing a KML file to extract POIs into a CSV output'
  parser = ArgumentParser(description=description)
  parser.add_argument("--kml-path", required=True, type=str, help="full path to the KML input file to process, e.g. '/home/USER/input_file.kml'")
  parser.add_argument("--csv-path", required=True, type=str, help="full path to the CSV output file, e.g. '/home/USER/output_file.csv'")

  args = vars(parser.parse_args())

  print 'Found args:', args
  return args

def get_point_details(curr_feature):
  feat_title = curr_feature.GetField(0).decode('utf-8')
  feat_desc = curr_feature.GetField(1).decode('utf-8')

  point_details = {
    'title': feat_title.encode('utf-8'),
    'desc': feat_desc.encode('utf-8')
  }
  curr_geom = curr_feature.GetGeometryRef()
  if ('POINT'==curr_geom.GetGeometryName()):
    point_details['x'] = curr_geom.GetX();
    point_details['y'] = curr_geom.GetY();
    return point_details
  else:
    return point_details


def main():
  input_args = parse_input_parameters()
  kml_driver = ogr.GetDriverByName('KML')
  ds_kml = kml_driver.Open(input_args['kml_path'])
  csv_file = codecs.open(input_args['csv_path'], 'wb')
  csv_writer = csv.DictWriter(
    csv_file,
    fieldnames=['category','title','desc','x','y'],
    delimiter=',',
    quotechar='"',
    quoting=csv.QUOTE_NONNUMERIC
  )
  csv_writer.writeheader()
  for l_idx in range(ds_kml.GetLayerCount()-1):
    curr_layer = ds_kml.GetLayerByIndex(l_idx)
    print 'Processing layer %i: "%s", with %i features' % (l_idx, curr_layer.GetName(), curr_layer.GetFeatureCount())
    for feat_idx in range(curr_layer.GetFeatureCount()-1):
      curr_feature = curr_layer.GetFeature(feat_idx)
      curr_item = get_point_details(curr_feature)
      curr_item['category'] = curr_layer.GetName()
      # print 'Feature: %s' % (str(curr_item))
      csv_writer.writerow(curr_item)

  csv_file.close()

if __name__ == "__main__":
  main()

