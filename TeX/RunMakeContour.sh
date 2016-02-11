#!/bin/bash
for i in {0050..0074}
do
   math -script MakeContour.m $i
done
