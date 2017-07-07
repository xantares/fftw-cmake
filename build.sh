#!/bin/sh

wget -c http://fftw.org/fftw-3.3.6-pl2.tar.gz
rm -rf /tmp/fftw-3.3.6-pl2
tar xzf fftw-3.3.6-pl2.tar.gz -C /tmp
# cp -r /tmp/fftw-3.3.6 /tmp/fftw-3.3.6.copy && pushd /tmp/fftw-3.3.6.copy && ./configure && cat config.h && make && popd
cp -r * /tmp/fftw-3.3.6-pl2
cd /tmp/fftw-3.3.6-pl2
cmake -DCMAKE_INSTALL_PREFIX=~/.local -DENABLE_SSE2=ON -DENABLE_THREADS=ON -DENABLE_OPENMP=ON -DENABLE_FLOAT=ON -DENABLE_LONG_DOUBLE=ON .
# cat config.h
make VERBOSE=1 install -j2 && make tests && ctest
