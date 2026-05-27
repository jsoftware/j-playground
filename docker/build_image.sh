#!/bin/sh

cd `dirname "$(realpath $0)"`

IMG=emscripten/emsdk
TAG=latest

sudo docker rmi -f $IMG:$TAG
sudo docker build -t $IMG:$TAG .

echo "done.";sleep 2

