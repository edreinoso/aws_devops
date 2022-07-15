# This script makes sure that the EBS volume is not above
# the threshold (80%), otherwise the ebs volume is going
# to call a Lambda to extend the volume

for k in $(jq '.messages | keys | .[]' json_file.json); do
    value=$(jq -r ".messages[$k]" json_file.json);
    # Variable declaration
    path=$(jq -r '.path' <<< "$value");
    volumeId=$(jq -r '.volumeId' <<< "$value");
    size=$(jq -r '.volumeSize' <<< "$value");
    mountPoint=$(jq -r '.mountPoint' <<< "$value");
    mountNumber=$(jq -r '.mountNumber' <<< "$value");
    instanceId=$(jq -r '.instanceId' <<< "$value");
    timestamp=`date +%Y-%m-%d_%H:%M:%S`

    # Checking variables
    echo "$volumeId" "$path" >> ~/pass80percent.txt
    echo "$volumeId" "$path" >> ~/didNotPass80percent.txt

    ~/aws-scripts-mon/mon-put-instance-data.pl --disk-path="$path" --disk-space-util --verbose > ./ebsavailable.txt
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
        echo >> ~/pass80percent.txt
        if [[ $mountNumber == " " ]]; then
            mountNumber="empty"
        fi
        aws lambda invoke --function-name EBS_Extend --payload '{"document": "extend_ebs_volume","ebsInfo":[{"instanceId":"'$instanceId'", "volumeId":"'$volumeId'","ebsSize":"'$size'","path":"'$path'","mountPoint":"'$mountPoint'","mountNumber":"'$mountNumber'"}]}' response.json
        sleep 10
        ~/ebsExtend1.sh
    else
        echo "$timestamp do nothing on $path with $volumeId and $size" >> ~/didNotPass80percent.txt
                #echo >> ~/didNotPass80percent.txt
    fi
    #echo >> ~/didNotPass80percent.txt
done
echo >> ~/didNotPass80percent.txt