#!/bin/bash
#
# run build in docker image (non-interactive)

P=`dirname "$(realpath $0)"`
JSRC=$(dirname "$P")/jsource

docker run --rm \
 -v "$JSRC":/home/ubuntu/jsource \
 -u $(id -u):$(id -g) \
 emscripten/emsdk \
 jsource/script/build_wasm.sh

