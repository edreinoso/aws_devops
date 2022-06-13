import boto3

ssm = boto3.client('ssm')


def lambda_handler(event, context):
    instanceId = 'i-01d0fe003063b5b73'

    ssm.send_command(
        InstanceIds=[instanceId],
        DocumentName='eni-attachment',  # need to obtainde this value
        DocumentVersion='$LATEST',
        Comment='Attaching secondary network interface to instance'
    )
