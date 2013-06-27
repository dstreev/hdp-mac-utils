#!/bin/bash

FILE=$1
OLD=$2
NEW=$3
if [ $# -gt 3 ]; then
	SED_CMD="s$4$OLD$4$NEW$4g"
else
	SED_CMD="s:$OLD:$NEW:g"
fi

sed -i bak -e "$SED_CMD" $FILE

