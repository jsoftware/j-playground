#!/bin/bash
#
# called in jsource/script

set -evx

cd `dirname "$(realpath $0)"`/..
P=`pwd`
echo $P

mkdir -p bin/wasm/j32
rm -rf bin/wasm/j32/*

export AR=emar
export BACKTRACE_OBJS=
export CC=emcc
export FLAGS_BASE64=
export GASM_FLAGS=
export MAKEFLAGS=-j8
export NASM=nasm
export NASM_FLAGS=
export NO_SHA_ASM=1
export SHLVL=2
export SRC_ASM=
export TARGET=jamalgam.js
export USE_EMU_AVX=0
export USE_OPENMP=0
export USE_PYXES=0
export USE_SLEEF=0
export USE_SLEEFQUAD=1
export USE_WASM=1
export _DEBUG=0
export _SSE4_2=1exi
export j64x=j32
export jplatform=wasm

export LDFLAGS="-L../mpir/linux/wasm32 -lgmp \
 -sALLOW_MEMORY_GROWTH=1 \
 -sALLOW_UNIMPLEMENTED_SYSCALLS=1 \
 -sASSERTIONS=1 \
 -sBINARYEN_EXTRA_PASSES=--pass-arg=max-func-params@80 \
 -sEMULATE_FUNCTION_POINTER_CASTS=1 \
 -sEXPORTED_FUNCTIONS=_malloc,_free,_main,_em_jdo,_em_jinit,_em_jsetstr,_em_jgetstr \
 -sEXPORTED_RUNTIME_METHODS=cwrap,ccall,UTF8ToString,lengthBytesUTF8,stringToUTF8 \
 -sEXPORT_ES6=1 \
 -sFORCE_FILESYSTEM \
 -sINITIAL_MEMORY=220MB \
 -sMODULARIZE=1 \
 -sNO_EXIT_RUNTIME=1 \
 -sSTACK_SIZE=984KB \
 -sTOTAL_MEMORY=600MB \
 --embed-file ../addons/ \
 --embed-file ../labs/ \
 --embed-file ../jlibrary/ \
 --exclude-file *.dylib --exclude-file *.so --exclude-file *.dll \
 --exclude-file *.exe --exclude-file jconsole* --exclude-file jamalgam* \
 --exclude-file bin32 --exclude-file bin"

export CFLAGS="-fPIC -O2 -g2 -fvisibility=hidden -fno-strict-aliasing -fwrapv \
 -Werror -Wextra -Wno-unknown-warning-option -Wconstant-conversion -Wsign-compare \
 -Wtautological-constant-out-of-range-compare -Wtypedef-redefinition \
 -Wuninitialized -Wno-braced-scalar-init -Wno-cast-function-type-mismatch \
 -Wno-char-subscripts -Wno-consumed -Wno-delete-non-abstract-non-virtual-dtor \
 -Wno-deprecated-non-prototype -Wno-empty-body -Wno-gnu-folding-constant \
 -Wno-implicit-float-conversion -Wno-implicit-int-float-conversion \
 -Wno-incompatible-function-pointer-types -Wno-int-conversion \
 -Wno-int-in-bool-context -Wno-missing-braces -Wno-missing-field-initializers \
 -Wno-null-pointer-arithmetic -Wno-null-pointer-subtraction -Wno-parentheses \
 -Wno-pass-failed -Wno-pointer-sign -Wno-pointer-to-int-cast \
 -Wno-sometimes-uninitialized -Wno-string-plus-int -Wno-unknown-pragmas -Wno-unsequenced \
 -Wno-unused-but-set-variable -Wno-unused-function -Wno-unused-parameter \
 -Wno-unused-value -Wno-unused-variable \
 -DHTML=1 -DJAMALGAM -DPYXES=0 -DNORMAH8=0 -DSLEEF=0 -DSLEEFQUAD=1 \
 -I../mpir/include \
 -DEMU_AVX2=0 -DNO_SHA_ASM -m32 -DIMPORTGMPLIB -DCSTACKSIZE=1007616 \
 -DCSTACKRESERVE=100000 -Wno-cast-function-type-mismatch"

#-D TESTS

export OBJS_BASE64=" \
  ../base64/lib/arch/avx2/codec.o \
  ../base64/lib/arch/avx512/codec.o \
  ../base64/lib/arch/generic/codec.o \
  ../base64/lib/arch/neon32/codec.o \
  ../base64/lib/arch/neon64/codec.o \
  ../base64/lib/arch/ssse3/codec.o \
  ../base64/lib/arch/sse41/codec.o \
  ../base64/lib/arch/sse42/codec.o \
  ../base64/lib/arch/avx/codec.o \
  ../base64/lib/lib.o \
  ../base64/lib/codec_choose.o \
  ../base64/lib/tables/tables.o "

cd make2
./clean.sh
cd ../jsrc
make -f ../make2/makefile-wasm
ls -l ../bin/wasm/j32

