#!/usr/bin/env python


# this script works with Python 2.7.4

# The main problem with CSV files exported from Microsoft Excel is carriage returns
# or some combination of them with strange characters. In the end I find myself dealing
# with long lines of data just because there is some problem with carriage returns.
# I can not use commands like grep or awk, so I found the following solution in Python.
#
# Description:
# - the input CSV file must have the first line containing the name of the columns
# - the column names will be rendered in camel case using the function "camelCase"
# - there's a "prependToString" function used for a column in position 2 (i=1 in the loop) 
#   just to be sure the leading zeros of a barcode are not wiped out by MongoDB 
#   in an automatic way when importing the data
#

# USAGE:
#
# your-path $ python csvExcelExporter.py inputFileExportedFromExcel.csv outputFile.csv
#
#


import csv
import sys # library to pass input parameters from the command line

ofile  = open(sys.argv[2], "w")
writer = csv.writer(ofile, delimiter='\t', quotechar='"', quoting=csv.QUOTE_ALL)

# function to transform 'make IT camel CaSe' to 'makeItCamelCase'
def camelCase(st):
    output = ''.join(x for x in st.title() if not x.isspace())
    return output[0].lower() + output[1:]

# prepend something to a string
def prependToString(st, prefix):
    output=prefix+st
    return output

# the loop on the CSV lines (assuming the CSV input file is an export from Microsoft Excel)
with open(sys.argv[1], 'rU') as csvIN:
    outCSV=(line for line in csv.reader(csvIN, dialect='excel'))

    # headers (first line of the file) are treated in a different way: in camel case
    writer.writerow([camelCase(headerItem) for headerItem in next(outCSV)])
    # all the other lines
    for row in outCSV:
        # cleaning all the line feeds in the cells 
        row = [rowItem.replace("\n"," ") for rowItem in row]
        # we want to prefix the barcode cell to then prevent mongodb from saving this cell as a number 
        for i,val in enumerate(row):
            if (i==1):
                row[i] = prependToString(row[i],"barcode")
        writer.writerow(row)

ofile.close()



# refere to:
#
# http://stackoverflow.com/questions/11146564/handling-extra-newlines-carriage-returns-in-csv-files-parsed-with-python
# http://www.linuxjournal.com/content/python-scripts-replacement-bash-utility-scripts
# http://www.pythonforbeginners.com/systems-programming/using-the-csv-module-in-python/
# https://docs.python.org/2/library/functions.html#open
# http://stackoverflow.com/questions/3136689/find-and-replace-string-values-in-python-list
# http://stackoverflow.com/questions/8347048/camelcase-every-string-any-standard-library
# http://stackoverflow.com/questions/4796764/read-file-from-line-2-or-skip-header-row
#
#
