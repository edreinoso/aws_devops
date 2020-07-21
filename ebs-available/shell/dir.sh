#!/bin/bash
#initializing important variables
logic=true
value="data"
n=0

while [ "$logic" != "false" ]
do
    x=`ls / | grep $value`
    # mkdir
    if [[ -z  $x ]]; then
        sudo mkdir /$value
        logic=false
    else
        ((n+=1)) #sum operations
        value="data"
        value="$value$n" # assigning new value
    fi
done

echo "Hello World, something after?"