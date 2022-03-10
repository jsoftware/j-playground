#!/bin/sh
# simple script to copy labs into this folder that have a chance of working with j-playground
grep -r --include "*.ijt" -L "LABDEPENDS\|load" ../labs_labs/ | xargs cp -t .
