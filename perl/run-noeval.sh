#!/bin/bash

./delete-population.pl
./initial-pop.pl 
./reproduce-pop-loop.pl &
./reaper.pl  
