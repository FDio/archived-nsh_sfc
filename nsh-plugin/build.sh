#!/usr/bin/env bash
NSH_PLUGIN_DIR=$(dirname $0)
NSH_INSTALL_PREFIX=${NSH_INSTALL_PREFIX:-/usr}
cd ${NSH_PLUGIN_DIR}
autoreconf -i -f
[ -d build ] ||  mkdir build
[ -d ${NSH_INSTALL_PREFIX} ] || mkdir -p ${NSH_INSTALL_PREFIX}
cd build
../configure --prefix ${NSH_INSTALL_PREFIX}
make V=1 PATH=${PATH}
${SUDOCMD-sudo} make PATH=${PATH} install
