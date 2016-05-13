#!/usr/bin/env bash
autoreconf -i -f
[ -d build ] ||  mkdir build
cd build
../configure --with-plugin-toolkit
make
sudo make install
