#!/bin/bash

if [ -z "1" ]
then 
    ITERATIONS=10
else
    ITERATIONS=$1
fi

echo "Running for $ITERATIONS";

for (( i=0; i < $ITERATIONS; i++ ))
do
    echo "Iteration $i"
    ./delete-population.pl 
    ./delete-population.pl
    ./initial-pop-with-eval.pl conf R-ip128-r64 
    ./mini-ga-sort-adapt.pl conf  R-ip128-r16 &
    ./mini-ga-sort-adapt.pl conf  R-ip128-r32 &
    ./mini-ga-sort-adapt.pl conf  R-ip128-r64
done