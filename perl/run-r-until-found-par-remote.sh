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
    RPAR=1
else
    RPAR=$3
fi

if [ -z "$4" ]
then 
    ITERATIONS=10
else
    ITERATIONS=$4
fi

echo "Running with $BASE for $ITERATIONS with $PARR repro";

for (( i=0; i < $ITERATIONS; i++ ))
do
    echo "Iteration $i"
    ./delete-population.pl 
    ./delete-population.pl
    ./initial-pop-with-eval.pl conf $BASE
     for (( j=0; j < $PARR; j++ ))
     do
	 ./repro-eval-until-found.pl conf  $BASE&
     done 
     for (( r=0; r < $RPAR; r++ ))
     do
	 ssh jmerelo@192.168.1.39 'cd proyectos/SofEA/perl; ./repro-eval-until-found.pl remote_conf  $BASE' &
     done 
    ./repro-reaper-until-found.pl conf   $BASE
done