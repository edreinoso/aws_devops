myinstanceid=`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id`
aws ec2 describe-volumes --filters Name=attachment.instance-id,Values=$myinstanceid > volume.json

# creating an empty json that will be populated
JSON_STRING=$(jq -n '{messages: []}')
echo "$JSON_STRING" > json_file.json

for k in $(jq '.Volumes | keys | .[]' volume.json); do
    value=$(jq -r ".Volumes[$k]" volume.json);
    # Variable declaration
    volumeId=$(jq -r '.VolumeId' <<< "$value");
    device=$(jq -r '.Attachments[].Device' <<< "$value");
    instanceId=$(jq -r '.Attachments[].InstanceId' <<< "$value")
    volumeSize=$(jq -r '.Size' <<< "$value");

    # Logic
    values=`echo "$volumeId" "$device"`;
    #echo "$values"
    mount_point=`echo $device | sed 's|.*s|xv|' | cut -d " " -f 1`
    directory=`df -h | grep $mount_point | rev | cut -d ' ' -f 1 | rev`
    mount_number=`df -h | grep $mount_point | cut -c10-10`
    echo "$volumeId" "$directory" "$volumeSize" "$instanceId" "$mount_point" "$mount_number"
    #echo "$volumeId" "$directory" "$instanceId"

    # only populate an object if the directory if directory has value
    if [ ! -z "$directory" ]; then
      object=$(jq --arg path "$directory" --arg instanceId "$instanceId" --arg vol "$volumeId" --arg size "$volumeSize" --arg mountPoint "$mount_point" --arg mountNumber "$mount_number" '.messages += [{"instanceId": $instanceId, "path": $path, "volumeId": $vol, "volumeSize": $size, "mountPoint": $mountPoint, "mountNumber": $mountNumber}]' json_file.json)
      printf "$object" > json_file.json
    fi
done