import boto3
import json
import time

ssm = boto3.client('ssm')


def lambda_handler(event, context):
    print(event)

    # instanceId = event['detail']['requestParameters']['instanceId']
    instanceId = 'i-01d0fe003063b5b73'

    ssm.send_command(
        InstanceIds=[instanceId],
        DocumentName='eni-attachment',  # need to obtainde this value
        DocumentVersion='$LATEST',
        Comment='Attaching secondary network interface to instance'
    )
