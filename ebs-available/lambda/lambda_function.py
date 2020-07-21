import boto3
import json
import time


def lambda_handler(event, context):
    # sleep()
    client = boto3.client('ec2')
    documentName = "ebs_available"  # need to create a new document in SSM
    # TODO implement
    # world = ""
    # part of the function that would come from creating a volume
    for elements in event['resources']:
        world = str(elements)
        print(world)
        cut_word = world[42:63]
        print(cut_word)
        # there should be a sleep function here
        time.sleep(40)
    # cut_word = "vol-09070abe737df7181"
    # cut_word = "vol-0d162f30126774dee"
        response = client.describe_volumes(
            VolumeIds=[
                cut_word,
            ],
        )
        # print(response['Volumes'])
        for foo in response['Volumes']:
            print(foo)
            for bar in foo['Attachments']:
                # print(type(bar))
                print(bar['InstanceId'])
                # need to change device from /dev/sdl to /dev/xvdl
                bar_word = bar['Device'][len(bar['Device'])-1:len(bar['Device'])]
                device = "/dev/xvd"+bar_word
                print(device)
                ssm = boto3.client('ssm')
                response = ssm.send_command(
                    InstanceIds=[bar['InstanceId']],
                    DocumentName=documentName,
                    DocumentVersion='$LATEST',
                    Comment='testing ssm.send_command from lambda',
                    # Parameters should be the drive in which volume is mounted
                    Parameters={
                        'Device': [device],
                    },
                )
        # print(type(world))
    # print(type(event['resources']))
    # print(type(event))
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
