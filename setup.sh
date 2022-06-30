#!/usr/bin/bash

export PROJECT_ROOT=$(pwd)

cd rootmacro/build
cmake
make
cd - > /dev/null

mix deps.get
mix escript.build