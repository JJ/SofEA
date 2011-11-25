#!/bin/bash

./delete-population.pl
./initial-pop.pl 128 512
./evaluate-pop-loop.pl 128 5000&
sleep 1
./reproduce-pop-loop.pl 128 5000&
./reaper.pl  128 5000
