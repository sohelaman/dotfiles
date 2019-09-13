#!/bin/bash

## `full_text`
freemem=$(free -h | grep 'Mem:' | awk '{print $3}')
echo ": $freemem"

exit 0
