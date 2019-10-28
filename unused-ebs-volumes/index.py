import boto3


def lambda_handler(event, context):
    ec2 = boto3.resource('ec2', event['region'])
    i = 1


    volumes = ec2.volumes.filter(
        Filters=[{
            'Name': 'status',
            'Values': ['available']
        }]
    )

    for volume in volumes:
        v = ec2.Volume(volume.id)
        print(str(i) + 'Deleting EBS volume: ' + str(v.id) + ', Size: ' + str(v.size) + 'GiB')
        i += 1
