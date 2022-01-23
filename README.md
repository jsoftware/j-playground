# J Playground

A web-based J console and tutorials for those who are new to the language and want to instantly explore J without locally installing the engine. (prototype under development)


Introduction
------------
This is a proof of concept compilation of unbox (a browser-based J console) into a wasm target. The code lives https://github.com/joebo/unbox/tree/wasm_poc

Demo: https://joebo.github.io/unbox/bin/html/emj.html   (todo: replicate this for jsoftware repo)

Introduction
------------

Unbox is a GPLv3 licensed version of the J programming language interpreter derived from the initial J Software source release. The goals of this project are to provide bug fixes in the short term and language enhancements and new features in the long term. Although this is intended to be used as a drop in replacement for the J shared library the behavior of the interpreter and the definition of the language itself will likely diverge from the official J Software version over time.

Building
--------

### Prerequisites

```
docker pull emscripten/emsdk
# mapping /tmp to /host_tmp to make it easier to work with on the host os (not required)
docker run -p 8000:8000 -v /tmp:/host_tmp -it emscripten/emsdk bash

# on the docker container shell
cd /host_tmp
git clone https://github.com/joebo/unbox.git
cd unbox
git checkout wasm_poc
cd src/libj
````


-----
### Wasmer or wasmtime 

#### Pre-requisites
```
apt update && apt install -y libtinfo5

# for wasmer
curl https://get.wasmer.io -sSfL | sh

# for wasmtime
curl https://wasmtime.dev/install.sh -sSf | bash
```

#### Building

1. make -f makefile.wasmer clean j
2. /root/.wasmer/bin/wasmer ../../bin/wasmer/emj.wasm

-----
### HTML
The HTML build embeds the browser-based engine in a webpage

1. apt update && apt install -y python2
2. make -f makefile.html clean j
3. cd ../../bin/html && python2 -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'

### Linux 

#### Pre-requisites
```
apt update && apt install -y g++-multilib
```
#### Building

1. make -f makefile.linux clean j
2. ../../bin/linux/emj

