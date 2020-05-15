# jq '.data.messages += [{"date": "2010-01-07T19:55:99.999Z", "xml": "xml_samplesheet_2017_01_07_run_09.xml", "status": "OKKK", "message": "metadata loaded into iRODS successfullyyyyy"}]' input.json > input3.json
# jq '.messages += [{"path": "hello", "volumeId": "world"}]' input2.json > input3.json
# jq '.messages += [{"path": "hello", "volumeId": "world"}]' input2.json

# JSON_STRING=$( jq -n --arg bn "$BUCKET_NAME" --arg on "$OBJECT_NAME" --arg tl "$TARGET_LOCATION" '[{bucketname: "$bn", objectname: "$on", targetlocation: "$tl"}]' )
JSON_STRING=$( jq -n '{messages: []}' )
echo "$JSON_STRING" > localFile.json

# data{object} messages[array]
# printf "$JSON_STRING"

#1st load
directory="/ebs"
volumeId="vol-070fb81e0d7398a39"
# jq '.messages += [{"date": "hello", "xml": "xml_samplesheet_2017_01_07_run_09.xml", "status": "OKKK", "message": "metadata loaded into iRODS successfullyyyyy"}]' $JSON_STRING > input2.json
object=$(jq --arg path "$directory" --arg vol "$volumeId" '.messages+= [{"path": $path, "volumeId": $vol}]' localFile.json)
echo "$object" > localFile.json

#2nd load
directory="/app"
volumeId="vol-035d892a8d9797b22"
# jq '.messages += [{"path": "hello", "volumeId": "world"}]' input2.json
# hello=$(jq '.messages += [{"path": "hello", "volumeId": "world"}]' $object)
object=$(jq --arg path "$directory" --arg vol "$volumeId" '.messages+= [{"path": $path, "volumeId": $vol}]' localFile.json)
echo "$object" > localFile.json
# printf "$hello"
# jq -n --arg path "$directory" --arg vol "$volumeId" '.messages += [{"path": $path, "volumeId": $vol}]' $object > input2.json


# #3rd load
directory="/data"
volumeId="vol-019a2f9740a74a7a9"
object=$(jq --arg path "$directory" --arg vol "$volumeId" '.messages+= [{"path": $path, "volumeId": $vol}]' localFile.json)
echo "$object" > localFile.json


# printf "$object"