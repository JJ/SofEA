#!/bin/bash

if [ -z "$1" ]
then 
    BASE="base"
else
    BASE="$1"
fi

if [ -z "$2" ]
then 
    PARE=2
else
    PARE=$2
fi

if [ -z "$3" ]
then 
    PARR=$PARE
else
    PARR=$3
fi

if [ -z "$4" ]
then 
    ITERATIONS=10
else
    ITERATIONS=$4
fi

echo "Running with $BASE for $ITERATIONS with $PARE eval and $PARR repro";

for (( i=0; i < $ITERATIONS; i++ ))
do
    echo "Iteration $i"
    ./delete-population.pl 
    ./delete-population.pl
    ./initial-pop.pl conf $BASE
    for (( j=0; j < $PARE; j++ ))
    do 
	./evaluate-pop-loop-until-found.pl conf  $BASE&
    done
     for (( j=0; j < $PARR; j++ ))
     do
	 ./reproduce-pop-loop-until-found.pl conf  $BASE&
     done 
    ./reaper-until-found.pl conf   $BASE
done