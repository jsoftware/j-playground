Versions for testing
-------
1. https://jsoftware.github.io/j-playground/bin/html/ - Original Proof of Concept
2. https://jsoftware.github.io/j-playground/bin/html2/ - 2018 J Playground (much improved) ported to WASM engine - work in progress.

Developing
---------
1. HTML/JS for the latest playground is in bin/html2 and is accessible from github pages (https://jsoftware.github.io/j-playground/bin/html2/). The older prototype playground is in bin/html. Files can be directly edited in these folders to make modifications. Later we may move the source out and keep those folders for produciton builds of the html/js
2. J Engine is in jsrc. The playground startup is in emj.c. The solution can be built with the makefile.* files (namely makefile.html). The main difference from stock jsrc and the playground jsrc is as follows: a.) stock j uses a dynamic library, instead all of the j code is linked into one binary. b.) some primitives such as mmap and other things don't work in wasm - these are primarily excluded from the build with #ifdef WASM in the source code or excluded in makefile.*
4. J Playground initialization J code is maintained in source/base and source/help and a build.py or jproject assembles it into emj.ijs, which is packaged in the html build. . Do not modify emj.ijs directly. Instead use the smaller, structured files in source.

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
2. cd ../bin/html && python3 -m http.server

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

## Testing

Use emrun to test from within the emscripten docker image. 

Firefox installation: 
1. apt install firefox

Chrome Installation:
1. Google if you'd like to. I skipped this because chrome needed a full x11 and was a large installation

Emrun: https://emscripten.org/docs/compiling/Running-html-files-with-emrun.html

1. Firefox: emrun --browser=firefox --hostname=localhost --kill_exit --browser_args="--headless" /host_tmp/bin/tests/index.html  2>>/dev/null | grep -v GFX
1. Chrome: emrun --browser=chrome --hostname=localhost --kill_exit --browser_args="--headless --remote-debugging-port=0 --disable-gpu --disable-software-rasterizer" /host_tmp/bin/tests/index.html

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
