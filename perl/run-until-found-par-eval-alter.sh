#!/bin/bash

if [ -z "$1" ]
then 
    BASE="base"
else
    BASE="$1"
fi

if [ -z "$2" ]
then 
    ALTER="base"
else
    ALTER="$2"
fi

if [ -z "$3" ]
then 
    PAR=1
else
    PAR=$3
fi

if [ -z "$4" ]
then 
    ITERATIONS=10
else
    ITERATIONS=$4
fi


echo "Running with $BASE and $ALTER for $ITERATIONS with $PAR evals";

for (( i=0; i < $ITERATIONS; i++ ))
do
    echo "Iteration $i"
    ./delete-population.pl 
    ./delete-population.pl
    ./initial-pop.pl conf $BASE
    ./evaluate-pop-loop-until-found.pl conf  $BASE&
    for (( j=0; j < $PAR; j++ ))
    do 
        echo Starting alter $j
	./evaluate-pop-loop-until-found.pl conf  $ALTER&
    done
    ./reproduce-pop-loop-until-found.pl conf  $BASE&
    ./reaper-until-found.pl conf   $BASE
done