import boto3
from createTag import createTag

# Global variables
ec2_tag_value = []

ec2_tag_key = []

eni_ids = []


def lambda_handler(event, context):
    # function variables
    d = 0
    x = 0  # this is to take more than one instance
    y = 0  # this would be to go inside of the eni variable
    len_tags = 0
    value = ''
    tag_class = createTag()
    areThereEC2Tags = 'Tags'
    
    client = boto3.client('ec2', event['region'])

    ec2 = client.describe_instances(
        Filters=[
            # {
            #     'Name': 'vpc-id',
            #     'Values': [event['']]
            # },
            # {
            #     'Name': 'tag:Test',
            #     'Values': ['Y']
            
            # },
        ],
    )
    
    print('\n')

    for reservation in ec2["Reservations"]:
        
        # print(reservation)

        for instance in reservation["Instances"]:

            print('instance id: ' + instance['InstanceId'])

            # 1st part: Put the instance tags in a variable in order
            # to do some comparison
            if areThereEC2Tags in instance:
                # print('There is a tag inside of this instance')
                len_tags = len(instance['Tags'])
                for tags in instance["Tags"]:
                    # print(type(tags))
                    # print('length of tags: ' + str(len_tags))    
                    # print('this is D: ' + str(d))
                    print('tag key: ' + tags['Key'] + ' tag value: ' + tags['Value'])
                    if (tags['Key'] == 'Name'):
                        # value = tags['Value']
                        
                        ec2_tag_key.append(tags['Key'])
                        ec2_tag_value.append(tags['Value'])
                        # print(type(ec2_tag_value))
                        # print(len(ec2_tag_value))
                        print('\tYY - ec2 tag - key: ' + ec2_tag_key[x] + ' value: ' + ec2_tag_value[x])
                        break
                    elif (d >= len_tags-1):
                    # elif (tags['Key'] != 'Name'):
                    # # elif (d >= len_tags-1 and tags['Key'] != 'Name'):
                        print('d is last and no name tag for ec2 instance')
                        ec2_tag_key.append('Name')
                        ec2_tag_value.append('')
                        print('\tXX - ec2 tag - key: ' + ec2_tag_key[x] + ' value: ' + ec2_tag_value[x])
                    print('\n')
                    d += 1
                d = 0


                # 2nd part: Get the ENI of those ec2 instances
                # and store in variable
                for nic in instance["NetworkInterfaces"]:
                    eni_ids.append(nic['NetworkInterfaceId'])
                    print('eni id: ' + eni_ids[y])
                    
                    ec2_eni = client.describe_network_interfaces(
                        NetworkInterfaceIds=[
                            eni_ids[y]
                        ],
                    )
                    
                    for networkinterfaces in ec2_eni['NetworkInterfaces']:
                        # testing line
                        # print('Size of tagset ' + str(len(networkinterfaces['TagSet'])))
                        print('network interface id: ' + networkinterfaces['NetworkInterfaceId'])
                    
                        # this if would help as an error checker.
                        if (len(networkinterfaces['TagSet']) > 0):
                            for nic_tags in networkinterfaces['TagSet']:
                                # We want to check for the key 'name'
                                if (nic_tags['Key'] == 'Name'):
                                    # if the value is not equal the ec2 instance tag
                                    # print('len(ec2_tag_value): '+ str(len(ec2_tag_value)))
                                    # if(len(ec2_tag_value) > 0):
                                    if (ec2_tag_value[x] != ""):
                                        print('Not empty!!!')
                                        print('\tnic card name: ' + nic_tags['Value'] + ' - ec2-tag: ' + ec2_tag_value[x])
                                        if(nic_tags['Value'] != ec2_tag_value[x]):
                                            # testing lines
                                            print('####ENI name tag is not same as the ec2 instance name tag####')
                                            tag_class.create_tag(client, eni_ids[y], ec2_tag_key[x], ec2_tag_value[x])
                                    else:
                                        print('Empty!!!')
                                        print('\tnic card name: ' + nic_tags['Value'])
                                        tag_class.create_tag(client, eni_ids[y], 'Name', '')
                        else:
                            print('there are no tags in this nic, creating one ')
                            if (ec2_tag_value[x] != ""):
                                tag_class.create_tag(client, eni_ids[y], ec2_tag_key[x], ec2_tag_value[x])
                            else:
                                tag_class.create_tag(client, eni_ids[y], 'Name', '')
                    y += 1 # to loop to all the nics in an ec2 instance

            else:
                print('Please assign a tag to the instance: ' + instance['InstanceId'])

            x += 1 # to loop through all the instances
            print(x)
            print('\n')

    return ("Completed")
