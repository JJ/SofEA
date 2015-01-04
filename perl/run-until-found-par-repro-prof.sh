#!/bin/bash

if [ -z "$1" ]
then 
    BASE="base"
else
    BASE="$1"
fi

if [ -z "$2" ]
then 
    PAR=2
else
    PAR=$2
fi

if [ -z "$3" ]
then 
    ITERATIONS=10
else
    ITERATIONS=$3
fi

echo "Running with $BASE for $ITERATIONS with $PAR evals";

for (( i=0; i < $ITERATIONS; i++ ))
do
    echo "Iteration $i"
    ./delete-population.pl 
    ./delete-population.pl
    ./initial-pop.pl conf $BASE
    perl -d:NYTProf evaluate-pop-loop-until-found.pl conf  $BASE&
    for (( j=0; j < $PAR; j++ ))
    do 
	./reproduce-pop-loop-until-found.pl conf  $BASE&
    done
    ./reaper-until-found.pl conf   $BASE
done