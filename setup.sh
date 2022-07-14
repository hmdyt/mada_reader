#!/usr/bin/bash

export PROJECT_ROOT=$(pwd)
path_to_bin=$PROJECT_ROOT/bin

cd rootmacro/build
rm -rf *
cmake -DCMAKE_INSTALL_PREFIX=$path_to_bin ..
make install
cd - > /dev/null
export PATH=$path_to_bin:$PATH

mix local.hex --force
mix local.rebar --force
mix deps.get
mix escript.build
cp mada_reader $path_to_bin/.
rm mada_reader