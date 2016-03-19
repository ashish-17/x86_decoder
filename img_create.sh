#!/bin/bash
if [ "x$1" == "x" ]; then
	echo "Please provide an argument or two"
	return 1;
fi

TARGET=$2

if [ "x$TARGET" == "x" ]; then
	TARGET=`basename "$1"`.binhex
fi

TMPFILE=`mktemp`

echo "Converting $1 to $TARGET"

objcopy -j.text -O binary "$1" "$TMPFILE"
readelf -h "$1" | grep "Entry point address:"| awk '{printf "0x%08x\n", strtonum($NF)}' > "$TARGET"
hexdump -v -e '"0x%08x\n"' "$TMPFILE" >> "$TARGET"
