import boto3
import json

def lambda_handler(event, context):
    modifiedSize = 5  # variable to modify volume
    documentName = "helloworld"
    client = boto3.client('ec2')

    for volumeIterator in event["ebsInfo"]:
        # response = client.modify_volume(
        #   # DryRun=True|False,
        #   VolumeId=volumeIterator["volumeId"],
        #   Size=volumeIterator["ebsSize"]+modifiedSize,
        #   # VolumeType='standard'|'io1'|'gp2'|'sc1'|'st1',
        #   # Iops=123
        # )

        ssm = boto3.client('ssm')
        response = ssm.send_command(
            InstanceIds=[volumeIterator["instanceId"]],
            DocumentName=documentName,
            DocumentVersion='$LATEST',
            Comment='testing ssm.send_command from labda',
            # Parameters should be the drive in which volume is mounted
            # Parameters={
            #   'driveletter': [
            #       'D',
            #   ]
            # },
        )
    # return response['Command']['CommandId']
    # return {
    #     'statusCode': 200,
    #     'body': json.dumps(response)
    # }
