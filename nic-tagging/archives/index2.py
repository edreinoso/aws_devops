import boto3
from createTag import createTag
client = boto3.client('ec2')

# Global variables
ec2_tag_value = []

ec2_tag_key = []

eni_ids = []


def lambda_handler(event, context):
    # function variables
    x = 0
    y = 0  # this would be to go inside of the eni loop
    tag_class = createTag()
    areThereEC2Tags = 'Tags'

    ec2 = client.describe_instances(
        Filters=[
            {
                'Name': 'vpc-id',
                'Values': [event['workspaceVpcId']]
            },
        ],
    )

    for reservation in ec2["Reservations"]:

        for instance in reservation["Instances"]:

            # 1st part: Put the instance tags in a variable in order
            # to do some comparison
            if areThereEC2Tags in instance:
                print(
                    'Amazing, found a way to know whether there is a key inside of this dic')
                for tags in instance["Tags"]:
                    if (tags['Key'] == 'Name'):
                        ec2_tag_key.append(tags['Key'])
                        ec2_tag_value.append(tags['Value'])
                        print('ec2 tag - key: ' +
                              ec2_tag_key[x] + ' value: ' + ec2_tag_value[x])

                # 2nd part: Get the ENI of those ec2 instances
                # and store in variable

                # there is an issue with the tag, it is not looping
                # currently it is just referring to the x, which is the outter. it has to refer to the inner
                for nic in instance["NetworkInterfaces"]:
                    eni_ids.append(nic['NetworkInterfaceId'])
                    # testing line
                    # print('eni id: ' + eni_ids[y])

                    # 3rd part: Describe the attributes from those nic card
                    # gotten in step above, drilling down to the tag attribute
                    ec2_eni = client.describe_network_interfaces(
                        NetworkInterfaceIds=[
                            eni_ids[y]
                        ],
                    )
                    for networkinterfaces in ec2_eni['NetworkInterfaces']:
                        # testing line
                        # print('network interface id: ' +
                        #       networkinterfaces['NetworkInterfaceId'])

                        if (len(networkinterfaces['TagSet']) > 0):
                            for nic_tags in networkinterfaces['TagSet']:
                                # We want to check for the key 'name'
                                if (nic_tags['Key'] == 'Name'):
                                    # if the value is not equal the ec2 instance tag
                                    if(nic_tags['Value'] != ec2_tag_value[x]):
                                        # testing lines
                                        # print(
                                        #     'ENI name tag is not same as the ec2 instance name tag')
                                        # assign a value for that specific key
                                        # based on those resources obtained in the step 2

                                        tag_class.create_tag(
                                            client, eni_ids[y], ec2_tag_key[x], ec2_tag_value[x])
                                    # testing lines
                                    # print('This loop gave me the Name tag')
                                print('eni id: ' + eni_ids[y] 'nic tag - key: ' +
                                      nic_tags['Key'] + ' value: ' + nic_tags['Value'])
                        else:
                            tag_class.create_tag(
                                client, eni_ids[y], ec2_tag_key[x], ec2_tag_value[x])
                    y += 1

            else:
                print('Please assign a tag to the instance: ' +
                      instance['InstanceId'])

            x += 1
            print(x)
            print('\n')

    return ("Completed")
