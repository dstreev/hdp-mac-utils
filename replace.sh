#!/bin/bash

################################################
#   Copyright 2013 David Streever
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
################################################

FILE=$1
OLD=$2
NEW=$3
if [ $# -gt 3 ]; then
	SED_CMD="s$4$OLD$4$NEW$4g"
else
	SED_CMD="s:$OLD:$NEW:g"
fi

sed -i bak -e "$SED_CMD" $FILE

