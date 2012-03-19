#!/bin/bash

if [ -z "$1" ]
then 
    ITERATIONS=10
else
    ITERATIONS=$3
fi

echo "Running with $BASE for $ITERATIONS with $PARR repro";

for (( i=0; i < $ITERATIONS; i++ ))
do
    echo "Iteration $i"
    ./delete-population.pl 
    ./delete-population.pl
    ./initial-pop-with-eval.pl conf  e-ir128
    ./elite-ga.pl conf  e-ir64&
    ./elite-ga.pl conf  e-ir128
done