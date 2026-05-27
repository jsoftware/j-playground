#!/bin/bash
#
# run build in docker image (interactive)

P=`dirname "$(realpath $0)"`
JSRC=$(dirname "$P")/jsource

docker run -it --rm \
 -v "$JSRC":/home/ubuntu/jsource \
 -u $(id -u):$(id -g) \
 emscripten/emsdk \
 bash -c "jsource/script/build_wasm.sh;bash"

