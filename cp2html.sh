#!/bin/bash
#
# getrest
#
# run this after build

cd `dirname "$(realpath $0)"`
cp jsource/bin/wasm/j32/* bin/html2
