#LAMBDA

aws lambda invoke \
    --function-name EBS_Extend \
    --payload '{"ebsInfo":[{"volumeId":"vol-019a2f9740a74a7a9","ebsSize":20}]}' \
    response.json


aws lambda invoke --function-name EBS_Extend --payload '{"ebsInfo":[{"instanceId":"i-01e451440e8b746d7","volumeId":"vol-019a2f9740a74a7a9","ebsSize":"20"}]}' response.json

aws lambda invoke --function-name EBS_Extend \
    --payload '{"document":"extend_ebs_volume","ebsInfo":[{"instanceId":"i-04a89980401b186bc","volumeId":"vol-019a2f9740a74a7a9","ebsSize":"30","path":"/data"}]}' \
    response.json

##SSM

aws ssm create-document --content file://path/to/file/documentContent.json \ --name "ExampleDocument" --document-type "Command" --tags "Key=TaskType,Value=MyConfigurationUpdate"

aws ssm update-document \
    --name "extend_ebs_volume" \
    --content "file://extending_ssm.json" \
    --document-version '$LATEST'

aws ssm update-document-default-version \
    --name "extend_ebs_volume" \
    --document-version "27"

aws ssm send-command \
    --document-name "extend_ebs_volume" \
    --parameters commands=["/data"] \
    --targets "Key=instanceids,Values=i-04a89980401b186bc"