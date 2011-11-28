#!/bin/bash

./delete-population.pl
./initial-pop.pl conf par-repro
./evaluate-pop-loop.pl conf par-repro&
./reproduce-pop-loop.pl conf par-repro&
./reproduce-pop-loop.pl conf par-repro&
./reaper.pl  conf par-repro
