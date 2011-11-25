#!/bin/bash

./delete-population.pl
./initial-pop.pl 128 512
./evaluate-pop-loop.pl 64 10000&
sleep 1
./reproduce-pop-loop.pl 32 10000&
./reproduce-pop-loop.pl 32 10000&
./reaper.pl  64 10000
