#!/bin/bash

# myipaddress=`hostname -I | awk '{print $1}'`
# myinstanceid=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
# aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$myinstanceid > volume.json
# path='app'
# volumeId='vol-035d892a8d9797b22'

# creating an empty json that will be populated
JSON_STRING=$(jq -n '{messages: []}')
echo "$JSON_STRING" > json_file.json

# array=(
#   'path::ebs'
#   'volumeid::vol-002aa2180ab393327'
# )

# array+=(
#   "path::$path"
#   "volumeid::$volumeId"
# )

# for index in "${array[@]}" ; do
#     KEY="${index%%::*}"
#     VALUE="${index##*::}"
#     # echo "$KEY - $VALUE"
# done

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
      # object=$(jq `.data.messages += [{"path": "$directory", "volumeId": "$volumeId"}]`)
      printf "$object" > json_file.json
    fi
done


# for index in "${object[@]}" ; do
#   KEY="${index%%::*}"
#   VALUE="${index##*::}"
#   echo "$KEY - $VALUE"
# done


# declare -a arr

# arr["key1"]=val1

# arr+=(["key2"]=val2 ["key3"]=val3)
# arr+=(["key4"]=val4 ["key5"]=val5)

# for key in ${!arr[@]}; do
#     echo ${key} ${arr[${key}]}
# done