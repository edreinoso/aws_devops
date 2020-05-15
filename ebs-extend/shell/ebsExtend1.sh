#!/bin/bash

# myinstanceid=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
# aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$myinstanceid > volume.json

# creating an empty json that will be populated
JSON_STRING=$(jq -n '{messages: []}')
echo "$JSON_STRING" > json_file.json

for k in $(jq '.Volumes | keys | .[]' volume.json); do
    value=$(jq -r ".Volumes[$k]" volume.json);
    # Variable declaration
    volumeId=$(jq -r '.VolumeId' <<< "$value");
    device=$(jq -r '.Attachments[].Device' <<< "$value");

    # Logic
    values=`echo "$volumeId" "$device"`;
    mount_point=`echo $device | sed 's|.*s|xv|' | cut -d " " -f 1`
    directory=`lsblk | grep $mount_point | sed 's|.*/||' | cut -d " " -f 1`
    echo "$volumeId" "$directory"
    
    # only populate an object if the directory if directory has value
    if [ ! -z "$directory" ]; then
      object=$(jq --arg path "$directory" --arg vol "$volumeId" '.messages += [{"path": $path, "volumeId": $vol}]' json_file.json)
      printf "$object" > json_file.json
    fi
done