#!/bin/bash
#
# kill port $1

p=`lsof -F 'p' -i:$1`

if [ -n "$p" ]; then
 for f in $p; do
  kill -9 "${f:1}"
 done
fi

