#!/bin/bash
#clear ; date +%T ; sleep 1 ; clear ; date +%T ; sleep 1
#to keep running this in loop we are using while


#if you want your watch in different colors
#you can use so that we can use these
Red=$'\e[1;31m'
Grren=$'\e[1;32m'
Blue=$'\e[1;34m'
while true
do
    clear  
    echo $Blue $(date +%T)
    sleep 1
done
