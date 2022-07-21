import boto3
client = boto3.client('ec2')


def lambda_handler(event, context):
    tags_name = 'Tags'
    ec2 = client.describe_instances()

    for aws in ec2['Reservations']:
        for instance in aws['Instances']:
            if tags_name in instance:
                for tags in instance["Tags"]:
                    if (tags['Key'] == 'Name'):
                        instance_name_tag_value = tags['Value']
                        # print('instance name tag: ' + instance_name_tag_value)

            volume = client.describe_volumes(
                Filters=[
                    {
                        'Name': 'attachment.instance-id',
                        'Values': [instance["InstanceId"]]
                    }
                ]
            )

            for ebs in volume["Volumes"]:
                create_tag(ebs["VolumeId"], instance_name_tag_value)
        # print('\n')


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
