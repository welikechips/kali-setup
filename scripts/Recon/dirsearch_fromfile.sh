#!/bin/bash
# Description: DirSearch - Run Multiple URLS

if [ ! -d "/root/tools/dirsearch" ]; then
    echo "Make sure you run dirsearch Install"
else
    path=$(pwd)
    read -r -p 'Please enter full path of file ' file
    mkdir -p $path/dirsearch
    name=$(cat "$file")
    for i in $name; do
            echo https://$i
            dirsearch -u http://$i -w /usr/share/wordlists/dirb/big.txt -f -t 100 -r -e php,html,js,txt,asp,aspx -x 403 --simple-report=dirsearch/$i
    done
fi