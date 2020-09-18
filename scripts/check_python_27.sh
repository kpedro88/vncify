#!/bin/bash

if [ -n "$1" ]; then
    PY27VERSION=2.7.18
    PY27NAME=Python-${PY27VERSION}
    PY27INSTALL=/usr/local/python2.7
    echo "Getting Python 2.7..."
    cd /tmp
    wget https://www.python.org/ftp/python/${PY27VERSION}/${PY27NAME}.tgz --no-check-certificate
    tar -xzf ${PY27NAME}.tgz
    rm -rf ${PY27NAME}.tgz
    cd ${PY27NAME}
    ./configure --prefix=$PY27INSTALL --enable-shared
    make
    make altinstall
    ln -s ${PY27INSTALL}/bin/python2.7 ${PY27INSTALL}/bin/python
    # clean up
    rm -rf ${PY27NAME}
fi
