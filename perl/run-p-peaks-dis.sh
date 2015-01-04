#!/bin/bash

BASE=ppeaks-i500-r256

if [ -z "$1" ]
then 
    ITERATIONS=10
else
    ITERATIONS=$1
fi

echo "Running with $BASE for $ITERATIONS with $PARR repro";

for (( i=0; i < $ITERATIONS; i++ ))
do
    echo "Iteration $i"
    ./delete-population.pl 
    ./delete-population.pl
    ./initial-pop-with-ppeaks.pl conf $BASE
    ./p-peaks.pl conf  ppeaks-i500-r256&
    ./p-peaks.pl conf  ppeaks-i500-r128&
    ./p-peaks.pl conf  ppeaks-i500-r32&
    ./p-peaks.pl conf  ppeaks-i500-r32&
    ./p-peaks.pl conf  ppeaks-i500-r64&
    ./p-peaks.pl conf  ppeaks-i500-r64
done