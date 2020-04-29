# STEP 1a: import boto3, a library that will make the python code communicate with AWS resources.
import boto3
# STEP 2a: import a separate class which will be importing a function for name tagging
from createTag import createTag

# STEP 3a: declare global variables
ec2_tag_value = []  # variable for storing name values from ec2
ec2_tag_key = []  # note: "have to know what this is actually for."
eni_ids = []  # variable for storing the NIC ids from each EC2 instance.


def lambda_handler(event, context):
    # STEP 4a: use the client class from boto3. This will let your code have access to the EC2 instance
    # resources in the environment
    # Documentation: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html#client
    client = boto3.client('ec2')


# STEP 5a: declare inscope variables
    instance_loop = 0  # looper variable: for going through a series of instances
    instance_tag_loop = 0  # looper variable: for going through all the tags in the instance.
    eni_loop = 0  # looper variable: for going through all the NICs in a particular instance
    tag_class = createTag() # variable for invoking method that would assign name values to NICs
    areThereEC2Tags = 'Tags'  # variable for error handling
    len_tags = 0  # variable for determining the exact number of NICs that an instance has

# STEP 6a: make use of the describe_instance() method from the ec2 client variable
    ec2 = client.describe_instances()


# STEP 1b: iterate through the instances
    for instance in ec2["Instances"]:
        # DEBUGGING: this will print out the instance id
        print('instance id: ' + instance['InstanceId'])

        # STEP 2b: Check if there are any tags in the selected instance
        # IMPORTANT: If there is no tag and the code doesn't
        # evaluate that, the code will crash
        if areThereEC2Tags in instance:

            # STEP 3b: assign the length of how many tags an instance is using
            len_tags = len(instance['Tags'])

            # STEP 4b: iterate through all the tags in the instance
            for tags in instance["Tags"]:
                # DEBUGGING: this will print out the tag KEY and VALUE
                print('tag key: ' + tags['Key'] +
                      ' tag value: ' + tags['Value'])

                # STEP 5b: comparison to know whether the Key is Name
                if (tags['Key'] == 'Name'):
                    # STEP 5.1b: append the key and the value in the global variables
                    ec2_tag_key.append(tags['Key'])
                    ec2_tag_value.append(tags['Value'])
                    # DEBUGGING: this will print out the NAME VALUE of the instance
                    print('\tYY - ec2 tag - key: ' +
                          ec2_tag_key[instance_loop] + ' value: ' + ec2_tag_value[instance_loop])
                    break

                # STEP 6b: if the code has found a tag with key Name,
                    # create one tag with Key Name and Value Empty.
                    # IMPORTANT: If there is no name tag there will be a logical
                    # error since we're assigning Name tag from EC2 to the NICs.
                elif (instance_tag_loop >= len_tags-1):
                    # DEBUGGING: just making sure to print out that
                    # instance does not have a Name tag
                    print('instance_tag_loop is last and no name tag for ec2 instance')
                    # STEP 6.1b: create a new tag which key is Name and value is blank
                    ec2_tag_key.append('Name')
                    ec2_tag_value.append('')
                    # DEBUGGING: this will print out the NAME VALUE of the instance
                    print('\tXX - ec2 tag - key: ' +
                          ec2_tag_key[instance_loop] + ' value: ' + ec2_tag_value[instance_loop])
                print('\n')

                instance_tag_loop += 1  # increase the count to go to the other value in the array

            instance_tag_loop = 0  # note: "what is this doing here?"

            # 2nd part: Get the ENI of those ec2 instances
            # and store in variable
            for nic in instance["NetworkInterfaces"]:
                eni_ids.append(nic['NetworkInterfaceId'])
                print('eni id: ' + eni_ids[eni_loop])

                ec2_eni = client.describe_network_interfaces(
                    NetworkInterfaceIds=[
                        eni_ids[eni_loop]
                    ],
                )

                for networkinterfaces in ec2_eni['NetworkInterfaces']:
                    # testing line
                    # print('Size of tagset ' + str(len(networkinterfaces['TagSet'])))
                    print('network interface id: ' +
                          networkinterfaces['NetworkInterfaceId'])

                    # this if would help as an error checker.
                    if (len(networkinterfaces['TagSet']) > 0):
                        for nic_tags in networkinterfaces['TagSet']:
                            # We want to check for the key 'name'
                            if (nic_tags['Key'] == 'Name'):
                                # if the value is not equal the ec2 instance tag
                                # print('len(ec2_tag_value): '+ str(len(ec2_tag_value)))
                                # if(len(ec2_tag_value) > 0):
                                if (ec2_tag_value[instance_loop] != ""):
                                    print('Not empty!!!')
                                    print(
                                        '\tnic card name: ' + nic_tags['Value'] + ' - ec2-tag: ' + ec2_tag_value[instance_loop])
                                    if(nic_tags['Value'] != ec2_tag_value[instance_loop]):
                                        # testing lines
                                        print(
                                            '####ENI name tag is not same as the ec2 instance name tag####')
                                        tag_class.create_tag(
                                            client, eni_ids[eni_loop], ec2_tag_key[instance_loop], ec2_tag_value[instance_loop])
                                else:
                                    print('Empty!!!')
                                    print('\tnic card name: ' +
                                          nic_tags['Value'])
                                    tag_class.create_tag(
                                        client, eni_ids[eni_loop], 'Name', '')
                    else:
                        print('there are no tags in this nic, creating one ')
                        if (ec2_tag_value[instance_loop] != ""):
                            tag_class.create_tag(
                                client, eni_ids[eni_loop], ec2_tag_key[instance_loop], ec2_tag_value[instance_loop])
                        else:
                            tag_class.create_tag(
                                client, eni_ids[eni_loop], 'Name', '')
                eni_loop += 1  # to loop to all the nics in an ec2 instance

        else:
            print('Please assign a tag to the instance: ' +
                  instance['InstanceId'])

        instance_loop += 1  # increase the count to go to the other value in the array
        print(instance_loop)
        print('\n')
