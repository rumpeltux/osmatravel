#!/bin/sh
SEP=""
for i in `cat unmatched.txt | tr " " "_"`; do
  FOO="$FOO$SEP@name=\"$i\""
  if [ "$SEP" = "" ]; then
    SEP=" or "
  fi
done
echo "/listings/*[$FOO]"
