#!/bin/bash
#
# getrest
#
# run this after reading in jsource

cd `dirname "$(realpath $0)"`
S=`pwd`

cd jsource

cp version.txt jsrc/jversion.h
echo '#define jplatform "wasm"' >> jsrc/jversion.h
echo '#define jlicense  "commercial"' >> jsrc/jversion.h
echo '#define jbuilder  "www.jsoftware.com"' >> jsrc/jversion.h

mkdir -p bin/wasm/j32
ln -fs bin/wasm/j32 .

cd jlibrary

rm -rf bin32
rm -rf tools/*
rm -f copy_library*
cp $S/extra/*.ijs bin

# ----------------------------------------------------------------------
# one off fix to stdlib to avoid uname errors
cd system/main
sed -i "/if\. IF64 +. IFIOS do./ c\if\. IF64 +. IFIOS +. UNAME -: 'Wasm' do." stdlib.ijs

# ----------------------------------------------------------------------
# one off fix to pacman to avoid non-wasm defs
cd ../util
F=pacman.ijs
s=`grep Wasm $F`
if [ -z "$s" ]; then
  sed -i "/VERNO=: 100 \#. n/a if. UNAME -: 'Wasm' do. EMPTY return. end." $F
fi

# ----------------------------------------------------------------------
cd $S
cp -r addons jsource
cp -r labs jsource
cp extra/emj.c jsource/jsrc
cp extra/wasm_stubs.h jsource/jsrc
cp extra/xh.c jsource/jsrc
cp makefile-wasm jsource/make2
cp build_wasm.sh jsource/script

