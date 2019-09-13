#!/bin/bash

## `full_text`
freeswap=$(free -h | grep 'Swap:' | awk '{print $3}')
echo ": $freeswap"

exit 0
