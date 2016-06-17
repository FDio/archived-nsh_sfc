#!/usr/bin/env bash
autoreconf -i -f
[ -d build ] ||  mkdir build
cd build
../configure --prefix /usr
make
sudo make install
