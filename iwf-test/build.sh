#!/bin/bash
project=iwf-test
scheme=$project
driver="iPhone 6"
##
##
PWD=`pwd`
rm -rf reports
xcodebuild -configuration Debug -scheme $scheme clean test -destination name="$driver"
odir=`cat object_file_dir`
mkdir reports
mkdir reports/html
mkdir reports/xml
gcovr --html --html-details -o reports/html/coverage.html -r $PWD/$project -v $odir
gcovr --xml -o reports/xml/coverage.xml -r $PWD/$project -v $odir