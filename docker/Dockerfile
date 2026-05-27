FROM emscripten/emsdk:latest

# Pre-activate the latest SDK (speeds up first build)
RUN emsdk install latest && emsdk activate latest

USER ubuntu
WORKDIR /home/ubuntu

