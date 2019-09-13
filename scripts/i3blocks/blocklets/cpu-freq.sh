#!/bin/bash

cpufreq=$(lscpu | grep 'CPU MHz:' | grep -o '[0-9]\+' | head -n1)

## `full_text`
printf '%s MHz\n' $cpufreq

## `short_text`
echo "$cpufreq"

## `color`
[ ${cpufreq} -gt 3000 ] && echo "#FFFF00"

## `background`
[ ${cpufreq} -gt 4000 ] && exit 33

exit 0
