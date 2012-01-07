#!/bin/bash

if [ -z "$1" ]
then 
    BASE="base"
else
    BASE="$1"
fi
if [ -z "$2" ]
then 
    ITERATIONS=10
else
    ITERATIONS=$2
fi
echo "Running with $BASE for $ITERATIONS";

for (( i=0; i < $ITERATIONS; i++ ))
do
    echo "Iteration $i"
    ./delete-population.pl 
    ./delete-population.pl
    ./initial-pop.pl conf $BASE
    ./evaluate-pop-loop-until-found.pl conf  $BASE&
    ./reproduce-pop-loop-until-found.pl conf  $BASE&
    ./reaper-until-found.pl conf   $BASE
done