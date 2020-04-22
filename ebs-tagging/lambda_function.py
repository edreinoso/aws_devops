import boto3
from createTag import createTag # would call an extra class that is in chargge of creating tags.

region='us-east-2'
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    tags_name = 'Tags'
    tag_volume = createTag()
    client = ec2.describe_volumes(
    )
    
    condition = 0
    
    for x in client['Volumes']:
        if tags_name in x:
            
            for y in x['Tags']:
                if (y['Key'] == 'EBS-DLM'):
                    break
                if condition >= len(x['Tags'])-1:
                    tag_volume.create_tag(ec2, x['VolumeId'], 'EBS-DLM', 'true')
                condition += 1
        else:
            tag_volume.create_tag(ec2, x['VolumeId'], 'EBS-DLM', 'true')
        condition = 0 # resetting condition