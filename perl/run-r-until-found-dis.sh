#!/bin/bash

if [ -z "$1" ]
then 
    ITERATIONS=10
else
    ITERATIONS=$1
fi

echo "Running with $BASE for $ITERATIONS with 3 different repro";

for (( i=0; i < $ITERATIONS; i++ ))
do
    echo "Iteration $i"
    ./delete-population.pl 
    ./delete-population.pl
    ./initial-pop-with-eval.pl conf R-i64-p128-r64
    ./repro-eval-until-found.pl conf  R-i64-p128-r64 &
    ./repro-eval-until-found.pl conf  R-i64-p128-r32 &
    ./repro-eval-until-found.pl conf  R-i64-p128-r16 &
    ./repro-reaper-until-found.pl conf  R-i64-p128-r64
done