#!/usr/bin/env bash

#This script outputs current usd to byn exchange rate.
while (true) 
do
  rate="$(curl -s "https://www.nbrb.by/engl/statistics/rates/ratesdaily/?p=true&" | grep -A 2 "US Dollar" | sed -n '/[0-9]*\.[0-9]*/p' | tr -d '[:space:]')"
  echo "$(date): 1 USD = $rate BYN"
  sleep 5;
done;