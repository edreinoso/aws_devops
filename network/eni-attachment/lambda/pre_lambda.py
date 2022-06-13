import boto3
import json
import time

ssm = boto3.client('ssm')
client = boto3.client('ec2')

def lambda_handler(event, context):
    print(event)

    for eni in event["ebsInfo"]:

        response = client.describe_instances(
            InstanceIds=[
                eni['InstanceId'],
            ],
        )

        nic0 = eni["path"]
        nic1 = eni["path"]

        response = ssm.send_command(
            InstanceIds=[eni["InstanceId"]],
            DocumentName=documentName,
            DocumentVersion='$LATEST',
            Comment='Asymmetric routing with two network interfaces in one host',
            Parameters={
                'NetworkInterface0': nic0,
                'NetworkInterface1': nic1,
            },
        )
