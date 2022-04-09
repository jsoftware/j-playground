Versions for testing
-------
1. https://jsoftware.github.io/j-playground/bin/html/ - Original Proof of Concept
2. https://jsoftware.github.io/j-playground/bin/html2/ - 2018 J Playground (much improved) ported to WASM engine - work in progress.

Building
--------

### Prerequisites

```
docker pull emscripten/emsdk
# mapping /tmp to /host_tmp to make it easier to work with on the host os (not required)
docker run -v /tmp:/host_tmp -it emscripten/emsdk bash

# on the docker container shell
cd /host_tmp
# depth 1 if you only need the last commit
git clone --depth 1 https://github.com/jsoftware/j-playground.git
cd j-playground
git checkout j903_wasm

cd jsrc

cp jversion-x.h jversion.h

````

### HTML

1. make -f makefile.html clean j
2. cd ../bin/html && php -S 127.0.0.1:9999

### Wasmer or wasmtime 

#### Pre-requisites

```
apt update
apt install -y libtinfo5

# for wasmer
curl https://get.wasmer.io -sSfL | sh

# for wasmtime
curl https://wasmtime.dev/install.sh -sSf | bash
```

#### Building

1. make -f makefile.wasmer clean j
1. wasmer ../bin/wasmer/emj.wasm

### Linux

#### Pre-requisites

```
apt update
apt install -y g++-multilib
```


#### Building

1. make -f makefile.linux clean j
1. ../bin/linux/emj

## emcc version
The version of emcc used for this experiment is shown below
```
root@d88fa49ccb67:/host_tmp/unbox/src/libj# emcc --version
emcc (Emscripten gcc/clang-like replacement + linker emulating GNU ld) 3.1.0 (8e1e305519e1027726a48861a1fec5662f7e18a2)
Copyright (C) 2014 the Emscripten authors (see AUTHORS.txt)
This is free and open source software under the MIT license.
There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
```
J903 proof of concept build in emscripten
