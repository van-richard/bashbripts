#!/bin/bash
#

COMPUTER=$(echo $HOSTNAME)

cat <<< $COMPUTER

if grep "oscer" <<< $COMPUTER /dev/null; then
    cat *oscer*.txt 
else
    echo "No Match"
fi
