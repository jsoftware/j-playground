#!/bin/bash
#
# run bash in docker image

P=`dirname "$(realpath $0)"`
JSRC=$(dirname "$P")/jsource

docker run -it  --rm \
 -v "$JSRC":/home/ubuntu/jsource \
 -u $(id -u):$(id -g) \
 emscripten/emsdk \
 bash
