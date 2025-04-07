#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <TEST_RUN_ID>"
    exit 1
fi

TEST_RUN_ID="$1"

number_of_requests=`cat "build/results/$TEST_RUN_ID/aggregate-simulation.log" | grep REQUEST | wc -l`
number_of_ok=`cat "build/results/$TEST_RUN_ID/aggregate-simulation.log" | grep REQUEST | awk -F $'\t' '{print $6}' | grep 'OK' | wc -l`
number_of_ko=`cat "build/results/$TEST_RUN_ID/aggregate-simulation.log" | grep REQUEST | awk -F $'\t' '{print $6}' | grep 'KO' | wc -l`

echo "Requests: $number_of_requests"
echo "OK: $number_of_ok"
echo "KO: $number_of_ko"
