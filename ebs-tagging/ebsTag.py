import boto3
from createTag import createTag

region='us-east-2'
ec2 = boto3.client('ec2', region_name=region)

def lambda_handler(event, context):
    tags_name = 'Tags'
    tag_volume = createTag()
    client = ec2.describe_volumes(
        # Filters=[
        #     {
        #         'Name': 'tag:Test',
        #         'Values': ['Y']
        #     },
        # ],
    )
    
    foo = 0
    # bar = 0
    
    for x in client['Volumes']:
        # print(x['VolumeId'])
        if tags_name in x:
            # bar += 1
            # print(str(bar) + ') no tags here: ' + x['VolumeId'])
            
            for y in x['Tags']:
                # print('foo: ' + str(foo) + '\t' + 'len(y): ' + str(len(x['Tags'])))
                # print('tag key: ' + y['Key'] + ' --- tag names: ' + y['Value'])
                if (y['Key'] == 'EBS-DLM'):
                    # print('you should break here!')
                    break
                if foo >= len(x['Tags'])-1:
                    # print('if variable not found, at the last then create a tag')
                    tag_volume.create_tag(ec2, x['VolumeId'], 'EBS-DLM', 'true')
                foo += 1
        else:
            # print('no tags here')
            tag_volume.create_tag(ec2, x['VolumeId'], 'EBS-DLM', 'true')
        foo = 0 # resetting foo
        
        # print('\n')