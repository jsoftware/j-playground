#!/bin/sh

set -e

cd `dirname "$(realpath $0)"`
cd html2

rm -f *.*~
rm -rf .DS_Store

p() { prettier --config ../.prettierrc.json --write "$1"; }

for s in about edit help layout localj log menu \
 pane popup start tbar term util; do 
 p "${s}.js"
done
