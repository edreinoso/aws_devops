import boto3
import json
import time


def lambda_handler(event, context):
    modifiedSize = 5  # variable to modify volume
    documentName = event["document"]
    client = boto3.client('ec2')

    for volumeIterator in event["ebsInfo"]:
        # print(type(volumeIterator["ebsSize"]))
        # print('instance id: ' + volumeIterator["instanceId"])

        response = client.modify_volume(
          VolumeId=volumeIterator["volumeId"],
          Size=int(volumeIterator["ebsSize"])+modifiedSize,
        )
        time.sleep(10)
        path = volumeIterator["path"]
        ssm = boto3.client('ssm')
        response = ssm.send_command(
            InstanceIds=[volumeIterator["instanceId"]],
            DocumentName=documentName,
            DocumentVersion='$LATEST',
            Comment='testing ssm.send_command from lambda',
            # Parameters should be the drive in which volume is mounted
            Parameters={
                'VolumePath': [volumeIterator["path"]],
                'MountPoint': [volumeIterator["mountPoint"]],
                'MountNumber': [volumeIterator["mountNumber"]],
            },
        )
