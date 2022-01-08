Unbox
=====

Introduction
------------
This is a proof of concept compilation of unbox into a wasm target. The code lives https://github.com/joebo/unbox/tree/wasm_poc

Demo: https://joebo.github.io/unbox/bin/html/emj.html

Introduction
------------

Unbox is a GPLv3 licensed version of the J programming language interpreter derived from the initial J Software source release. The goals of this project are to provide bug fixes in the short term and language enhancements and new features in the long term. Although this is intended to be used as a drop in replacement for the J shared library the behavior of the interpreter and the definition of the language itself will likely diverge from the official J Software version over time.

Building
--------

### Prerequisites

```
docker pull emscripten/emsdk
# mapping /tmp to /host_tmp to make it easier to work with on the host os (not required)
docker run -v /tmp:/host_tmp -it emscripten/emsdk bash

# on the docker container shell
cd /host_tmp
git clone https://github.com/joebo/unbox.git
cd unbox
git checkout wasm_poc
cd src
cd libj
````

### HTML

1. make -f makefile.html
2. cd ../../bin/html && python2 -c 'import SimpleHTTPServer; SimpleHTTPServer.test() 

### Wasmer or wasmtime 

1. make -f makefile.wasmer
1. wasmer ../../bin/wasmer/emj.wasm

### Linux

1. make -f makefile.linux
1. ../../bin/linux/emj
