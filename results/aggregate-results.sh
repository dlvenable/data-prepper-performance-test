#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <RESULTS_ID>"
    exit 1
fi

RESULTS_ID="$1"

# This will clear the file
rm -f "build/results/$RESULTS_ID/aggregate-simulation.log"

find "build/results/$RESULTS_ID" -type f -name 'simulation.log' | while read file; do
    tail -n +2 "$file" >> "build/results/$RESULTS_ID/aggregate-simulation.log"
done
