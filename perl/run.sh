#!/bin/bash

./delete-population.pl
./initial-pop.pl 
./evaluate-pop-loop.pl &
./reproduce-pop-loop.pl &
./reaper.pl  
