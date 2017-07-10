#!/bin/sh

wget -c http://fftw.org/fftw-3.3.6-pl2.tar.gz
rm -rf /tmp/fftw-3.3.6-pl2
tar xzf fftw-3.3.6-pl2.tar.gz -C /tmp
# cp -r /tmp/fftw-3.3.6 /tmp/fftw-3.3.6.copy && pushd /tmp/fftw-3.3.6.copy && ./configure && cat config.h && make && popd
cd /tmp/fftw-3.3.6-pl2
./configure --enable-float --enable-sse2 --enable-avx --enable-threads
mv config.h config.h.autotools
cd -
cp * /tmp/fftw-3.3.6-pl2
cd /tmp/fftw-3.3.6-pl2
cmake -DCMAKE_INSTALL_PREFIX=~/.local -DENABLE_THREADS=ON -DENABLE_OPENMP=OFF -DENABLE_FLOAT=ON -DENABLE_LONG_DOUBLE=OFF -DENABLE_QUAD_PRECISION=OFF -DENABLE_SSE2=ON -DENABLE_AVX=ON .
# cat config.h
make VERBOSE=1 install -j2 && ctest
