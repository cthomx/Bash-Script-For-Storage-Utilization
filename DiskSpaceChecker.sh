#!/bin/bash


# author: cole thomas
# purpose: check how much free disk space you have
# and give you a warning if more than X percent.
# parameters: the percentage amount of disk space for the warning

echo -e '\nWelcome to the disk space system check'
echo How much disk space utilization threshold percentage triggers a warning?

# get user input
echo -e '\nPlease enter a number between 0 and 100 representing the utilization threshold percentage'

# ingest variable for percentage threshold
read userthreshold
echo -e '\nSystem confirming threshold is' $userthreshold

# used space
usedspace=$(df -P | grep /dev/nvme | awk '{print $3}' |awk '{SUM+=$1}END{printf "%d", SUM/(1024*1024)}')

# original space
originalspace=$(df -P | grep /dev/nvme | awk '{print $2}' |awk '{SUM+=$1}END{printf "%d", SUM/(1024*1024)}')

# percentage calculation
usedpercentage=$(bc <<<"scale=1; $usedspace / $originalspace * 100")

# tell some summary statistics to the end user
echo -e '\nYou have used' $usedspace 'GB out of' $originalspace 'GB, roughly' $usedpercentage 'percent'

# source: https://stackoverflow.com/questions/8654051/how-can-i-compare-two-floating-point-numbers-in-bash
if (( $(echo "$usedpercentage >= $userthreshold" | bc -l) )); then
  echo -e 'System utilization exceedes threshold. Please action accordingly or procure larger drive.\n'
else
  echo -e 'No action required. Storage utilization is below the threshold.\n'
fi
