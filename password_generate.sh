#!/bin/bash

#Simple Password Generate

echo "welcome to simple password generator"

sleep 3
echo "Please enter your password:"
read PASS_LENGTH

for p in $(seq 1 );
do
    openssl rand -base64 48 | cut -c1-$PASS_LENGTH
done
