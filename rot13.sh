#!/bin/bash

yellow='\e[1;33m'
green='\e[1;32m'
red='\e[1;31m'
no='\e[0m'

# Checks the number of arguments passed
if [ $# -ne 2 ]; then
    echo -e "${red}Usage: $0 [encode|decode] filename${no}"
    exit 1
fi

# Set variables
action=$1
file=$2

# Check if the file exists
if [ ! -f "${file}" ]; then
    echo -e "${yellow}File not found: ${file}${no}"
    exit 1
fi

if [ "$action" == "encode" ]; then
    # Takes file name and encodes it into ROT13
    echo -e "${green}Encoding ${file}...${no}"
    tr "A-Za-z" "N-ZA-Mn-za-m" < "${file}"
    exit 0
elif [ "$action" == "decode" ]; then
    # Takes file name and decodes it by ROT13
    echo -e "${green}Decoding ${file}...${no}"
    tr "N-ZA-Mn-za-m" "A-Za-z" < "${file}"
    exit 0
else
    echo -e "${red}Invalid action: ${action}. Use 'encode' or 'decode'.${no}"
    exit 1
fi
