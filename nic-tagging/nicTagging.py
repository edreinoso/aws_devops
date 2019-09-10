import boto3
from createTag import createTag

# Global variables
ec2_tag_value = []

ec2_tag_key = []

eni_ids = []


def lambda_handler(event, context):
    # function variables
    x = 0  # this is to take more than one instance
    y = 0  # this would be to go inside of the eni variable
    tag_class = createTag()
    areThereEC2Tags = 'Tags'

    client = boto3.client('ec2', event['region'])

    ec2 = client.describe_instances()

    for reservation in ec2["Reservations"]:

        # print(reservation)

        for instance in reservation["Instances"]:

            # print('instance id: ' + instance['InstanceId'])

            # 1st part: Put the instance tags in a variable in order
            # to do some comparison
            if areThereEC2Tags in instance:
                print(
                    'There is a tag inside of this instance')
                for tags in instance["Tags"]:
                    if (tags['Key'] == 'Name'):
                        ec2_tag_key.append(tags['Key'])
                        ec2_tag_value.append(tags['Value'])
                        print('ec2 tag - key: ' +
                              ec2_tag_key[x] + ' value: ' + ec2_tag_value[x])

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
                        # print('Size of tagset ' +
                        #       str(len(networkinterfaces['TagSet'])))
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
                                print('nic tag - key: ' +
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
