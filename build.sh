#!/bin/bash
PWD=`pwd`
rm -rf reports
xcodebuild -configuration Debug -scheme iwf clean test
odir=`cat object_file_dir`
mkdir reports
mkdir reports/html
mkdir reports/xml
gcovr --html --html-details -o reports/html/coverage.html -r $PWD/iwf -v $odir
gcovr --xml -o reports/xml/coverage.xml -r $PWD/iwf -v $odir