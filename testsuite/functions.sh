#!/bin/sh
CC=${CC:-gcc}
CCLINK=${CCLINK:-${CC} -Wl,--dynamic-linker=`echo ./ld*.so.*[0-9]`}
CXX=${CXX:-g++}
CXXLINK=${CXXLINK:-${CXX} -Wl,--dynamic-linker=`echo ./ld*.so.*[0-9]`}
PRELINK=${PRELINK:-../src/prelink -c ./prelink.conf -C ./prelink.cache --ld-library-path=. --dynamic-linker=`echo ./ld*.so.*[0-9]`}
srcdir=${srcdir:-`dirname $0`}
savelibs() {
  for i in $LIBS; do cp -p $i $i.orig; done
}
comparelibs() {
  for i in $LIBS; do
    cp -p $i $i.new
    echo $PRELINK -u $i.new
    $PRELINK -u $i.new || exit
    cmp -s $i.orig $i.new || exit
    rm -f $i.new
  done
}
