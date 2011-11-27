#!/bin/bash

./delete-population.pl
./initial-pop.pl conf parallel
./evaluate-pop-loop.pl conf parallel&
./evaluate-pop-loop.pl conf parallel&
./reproduce-pop-loop.pl conf parallel&
./reaper.pl  conf parallel
