import boto3
import json
import time

ssm = boto3.client('ssm')
client = boto3.client('ec2')


def lambda_handler(event, context):
    print(event)
    nicaddr = []

    instanceId = event['detail']['requestParameters']['instanceId']

    response = client.describe_instances(
        InstanceIds=[
            instanceId,
        ],
    )

    print(response)

    for ec2 in response['Reservations']:
        for instance in ec2['Instances']:
            for interface in instance['NetworkInterfaces']:
                nic = interface['PrivateIpAddress']

                ssm.send_command(
                    InstanceIds=[instanceId],
                    # InstanceIds=[instanceId],
                    DocumentName='eni-attachment',  # need to obtainde this value
                    DocumentVersion='$LATEST',
                    Comment='Attaching secondary network interface to instance',
                    Parameters={
                            'NetworkInterfaces': nic,
                    },
                )
                print(interface['PrivateIpAddress'])
                nicaddr.append(interface['PrivateIpAddress'])

    print(nicaddr)

    # response = ssm.send_command(
    #     InstanceIds=['i-07916e3aa03900039'],
    #     # InstanceIds=[instanceId],
    #     DocumentName='eni-attachment', # need to obtainde this value
    #     DocumentVersion='$LATEST',
    #     Comment='Attaching secondary network interface to instance',
    #     Parameters={
    #             'NetworkInterfaces': nicaddr,
    #     },
    # )
