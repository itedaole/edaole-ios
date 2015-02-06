#!/usr/bin/env bash

## Tuangou build script

PROJECTFILE=tuangouproject.xcodeproj


TARGETS=$(xcodebuild -list tuangouproject.xcodeproj | awk 'BEGIN{s=0}; /Targets:/ {s=1}; {if (s) {if (NF>0) {if ($NF!="Targets:") print $NF} else if(s=1) exit}}');


echo ${TARGETS}

