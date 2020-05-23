for k in $(jq '.messages | keys | .[]' json_file.json); do
    value=$(jq -r ".messages[$k]" json_file.json);
    # Variable declaration
    path=$(jq -r '.path' <<< "$value");
    volumeId=$(jq -r '.volumeId' <<< "$value");
    size=$(jq -r '.volumeSize' <<< "$value");
    timestamp=`date +%Y-%m-%d_%H:%M:%S`

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
        echo "$timestamp call lambda on $path with $volumeId and $size" >> ~/pass80percent.txt
        echo
        #aws lambda invoke --function-name EBS_Extend --payload '{"ebsInfo":[{"volumeId":"'$volumeId'","ebsSize":"'$size'"}]}' response.json
        ~/ebsExtend1.sh
    else
        echo "$timestamp do nothing on $path with $volumeId and $size"
        #echo "$timestamp do nothing on $path with $volumeId and $size" >> ~/didNotPass80percent.txt
        #echo >> ~/didNotPass80percent.txt
    fi
    #echo >> ~/didNotPass80percent.txt
done
#echo >> ~/didNotPass80percent.txt