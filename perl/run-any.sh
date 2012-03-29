#!/bin/bash

cd ../js;./deploy.sh;cd ../perl

if [ -z "$1" ]
then 
    echo "Usage $0 <program>  [conf || base] [clients || 1] [iterations || 10]"
else
    PROG="$1"
fi

if [ -z "$2" ]
then 
    BASE="base"
else
    BASE="$2"
fi

if [ -z "$3" ]
then 
    PARR=1
else
    PARR=$3
fi

if [ -z "$4" ]
then 
    ITERATIONS=10
else
    ITERATIONS=$4
fi

echo "Running $PROG with $BASE for $ITERATIONS with $PARR repro";

for (( i=0; i < $ITERATIONS; i++ ))
do
    echo "Iteration $i"
    ./delete-population.pl 
    ./delete-population.pl
    ./initial-pop-elite.pl conf $BASE
     for (( j=0; j < $PARR-1; j++ ))
     do
	 $PROG conf  $BASE&
     done 
     $PROG conf  $BASE
done