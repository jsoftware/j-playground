#!/bin/bash
#
# run all steps (docker interactive) after reading in jsource

cd `dirname "$(realpath $0)"`
./getrest.sh
docker/runitbuild.sh
./cp2html.sh

