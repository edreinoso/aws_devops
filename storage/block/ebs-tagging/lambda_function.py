import boto3

client = boto3.client('ec2')


def lambda_handler(event, context):
    tags_name = 'Tags'
    instance_id = event['detail']['requestParameters']['instanceId']
    volume_id = event['detail']['requestParameters']['volumeId']

    ec2 = client.describe_instances(
        InstanceIds=[
            instance_id
        ]
    )

    if tags_name in ec2['Reservations'][0]['Instances'][0]:
        ec2_tags = ec2['Reservations'][0]['Instances'][0]['Tags']
        for tag in ec2_tags:
            if (tag['Key'] == 'Name'):
                create_tag(volume_id, tag['Value'])

    return


def create_tag(volume_id, value):
    client.create_tags(
        Resources=[volume_id],
        Tags=[
            {
                'Key': 'Name',
                'Value': value
            },
        ]
    )
