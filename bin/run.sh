#!/bin/bash
#
# run new 8080 server in lib

cd `dirname "$(realpath $0)"`

./killport.sh 8080
sleep 1

cd html2
cp ../../jsource/bin/wasm/j32/* .
http-server &

read


