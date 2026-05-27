#!/bin/bash
#
# run all steps after reading in jsource

cd `dirname "$(realpath $0)"`
./getrest.sh
docker/runbuild.sh
./cp2html.sh
echo "done.";sleep 2

