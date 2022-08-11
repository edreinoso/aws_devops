"""
 IDEA:  
    Eventbridge would invoke the lambda function
        based on CloudTrail DetachedVolume API
    
    The function should be able to write to eventbridge
        it should also be able to tag the volume with
        a cleanup day

    The rule on the cleanup day should invoke the other
        lambda function to take a snapshot of the available
        volume and then delete it.
"""

import boto3

ec2 = boto3.resource('ec2')


def lambda_handler(event, context):
    volume_id = event['volumeId']

    """
     Describe volume:
       get the name tag to assign snapshot
    """
    volume = ec2.describe_volumes(
        VolumeIds=[
            volume_id,
        ],
    )

    name_tag = {}

    for tags in volume['Volumes'][0]['Tags']:
        if (tags['Key'] == 'Name'):
            name_tag['Key'] = tags['Key']
            name_tag['Value'] = tags['Value']

    """
     Create snapshot:
       with volume_id that passed through the events
    """
    ec2.create_snapshot(
        Description='description',
        VolumeId=volume_id,
        TagSpecifications=[
            {
                'ResourceType': 'snapshot',
                'Tags': [
                    {
                        'Key': name_tag['Key'],
                        'Value': name_tag['Value']
                    },
                ]
            },
        ],
    )

    """
     Delete EBS volume:
       with volume_id that passed through the events
    """
    ec2.delete_volume(
        VolumeId=volume_id,
    )
