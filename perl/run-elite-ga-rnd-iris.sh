#!/bin/bash

if [ -z "$1" ]
then 
    BASE="base"
else
    BASE="$1"
fi

if [ -z "$2" ]
then 
    PARR=1
else
    PARR=$2
fi

if [ -z "$3" ]
then 
    ITERATIONS=10
else
    ITERATIONS=$3
fi

echo "Running with $BASE for $ITERATIONS with $PARR repro";

for (( i=0; i < $ITERATIONS; i++ ))
do
    echo "Iteration $i"
    ./delete-population.pl iris
    ./delete-population.pl iris
    ./initial-pop-elite.pl iris $BASE
     for (( j=0; j < $PARR-1; j++ ))
     do
	 ./elite-ga-rnd.pl iris  $BASE&
     done 
     ./elite-ga-rnd.pl iris  $BASE
done