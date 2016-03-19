#!/bin/bash

if [ "x$1" == "x" ]; then
	echo "Please provide an argument or two"
	return 1;
fi

TARGET=$2

if [ "x$TARGET" == "x" ]; then
	TARGET=`basename "$1"`.objdump
fi

TMPFILE=`mktemp`

objdump -j .text -d $1 |grep "^ " | sed -e "s/#.\+//g" -e "s/<.\+>//g"   > ${TMPFILE}

diff ${TMPFILE} ${TARGET}

rm ${TMPFILE}