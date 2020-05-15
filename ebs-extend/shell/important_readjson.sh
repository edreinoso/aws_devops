for k in $(jq '.messages | keys | .[]' json_file.json); do
    value=$(jq -r ".messages[$k]" json_file.json);
    # Variable declaration
    path=$(jq -r '.path' <<< "$value");
    volumeId=$(jq -r '.volumeId' <<< "$value");

    # Checking variables
    echo "$volumeId" "$path"

    ~/aws-scripts-mon/mon-put-instance-data.pl --disk-path=/"$path" --disk-space-util --verbose > ./ebsavailable.txt
    head -1 ./ebsavailable.txt > ./shortEbsUsed.txt
    
    # getting the number value
    value=`cat shortEbsUsed.txt | sed 's/.*: //' | cut -d " " -f 1`
    echo $value

    threshold=80
    gt=$(echo "$value > $threshold" | bc -q )
    
    # return 1 if true ; O if not
    if [ $gt = 1 ]
    then
        echo "call lambda on $path with $volumeId"
    else
        echo "do nothing on $path with $volumeId" 
    fi
    echo
done