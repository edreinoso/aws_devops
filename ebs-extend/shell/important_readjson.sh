for k in $(jq '.messages | keys | .[]' localFile.json); do
    value=$(jq -r ".messages[$k]" localFile.json);
    # Variable declaration
    path=$(jq -r '.path' <<< "$value");
    volumeId=$(jq -r '.volumeId' <<< "$value");

    # Checking variables
    echo "$volumeId" "$path"

    ~/aws-scripts-mon/mon-put-instance-data.pl --disk-path=/"$path" --disk-space-avail --verbose > /ebs/ebsavailable.txt

    head -1 ./ebsavailable.txt > ./shortEbsUsed.txt
done