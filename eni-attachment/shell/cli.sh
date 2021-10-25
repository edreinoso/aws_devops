# cli for detaching and attaching network interface
## create, attach, detach
aws ec2 create-network-interface --cli-input-json
aws ec2 attach-network-interface --device-index 1 --instance-id i-01d0fe003063b5b73 --network-interface-id eni-00fd0a2f7cd87e8ec
aws ec2 detach-network-interface --attachment-id eni-attach-04c478f8e6bc17d91


## SSM Commands

aws ssm create-document \
    --content file:///Users/elchoco/aws/functions/eni-attachment/shell/eni_attachment_ssm.json \
    --name "eni-attachment" \
    --document-type "Command"

aws ssm create-document \
    --content file:///Users/elchoco/aws/functions/eni-attachment/shell/eni_attachment_ssm.json \
    --name "eni-attachment" \
    --document-type "Command" \
    --tags "Key=Name,Value=eni-attachment; Key=Template,Value=aws_devops; Key=Environment,Value=dev; Key=Application,Value=eni-attachment; Key=Purpose,Value=aws_automation_devops; Key=Creation_Date,Value=Aug_06_2021"

aws ssm update-document \
    --name "eni-attachment" \
    --content file:///Users/elchoco/aws/functions/eni-attachment/shell/eni_attachment_ssm.json \
    --document-version '$LATEST'

aws ssm update-document-default-version \
    --name "eni-attachment" \
    --document-version "2"

==

aws ssm update-document --name "eni-attachment" --content file://config_ssm.json --document-version '$LATEST'; aws ssm update-document-default-version --name "eni-attachment" --document-version "16"


aws ssm send-command --instance-ids [] --document-name "eni-attachment" --document-version "10" --parameters "commands=['']"