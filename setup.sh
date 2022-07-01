#!/usr/bin/bash

export PROJECT_ROOT=$(pwd)

cd rootmacro/build
cmake -DCMAKE_INSTALL_PREFIX=$PROJECT_ROOT/rootmacro/bin ..
make install
cd - > /dev/null
export PATH=$PROJECT_ROOT/rootmacro/bin:$PATH

mix deps.get
mix escript.build