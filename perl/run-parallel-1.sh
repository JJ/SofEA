#!/bin/bash

./initial-pop.pl 128 512
./evaluate-pop-loop.pl 64 5000&
sleep 1
./reaper.pl  64 5000
