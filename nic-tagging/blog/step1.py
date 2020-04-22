### PART 1 ###

# STEP 1a: import boto3, a library that will make the python code communicate with AWS resources.
import boto3
# STEP 1b: import a separate class which will be importing a function for name tagging
from createTag import createTag

# STEP 1c: declare global variables
ec2_tag_value = []  # variable for storing name values from ec2
ec2_tag_key = []  # note: "have to know what this is actually for."
eni_ids = []  # variable for storing the NIC ids from each EC2 instance.


def lambda_handler(event, context):
    # STEP 1d: use the client class from boto3. This will let your code have access to the EC2 instance
    # resources in the environment
    # Documentation: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html#client
    client = boto3.client('ec2', 'us-east-1')


# STEP 1e: declare inscope variables
    x = 0  # looper variable: for going through a series of instances
    d = 0  # looper variable: for going through all the tags in the instance.
    y = 0  # looper variable: for going through all the NICs in a particular instance
    # variable for invoking method that would assign name values to NICs
    tag_class = createTag()
    areThereEC2Tags = 'Tags'  # variable for error handling
    len_tags = 0  # variable for determining the exact number of NICs that an instance has

# STEP 1f: make use of the describe_instance() method from the ec2 client variable
    ec2 = client.describe_instances()

### PART 2 ###

# STEP 2a: iterate through the instances
    for instance in ec2["Instances"]:
        # DEBUGGING: this will print out the instance id
        print('instance id: ' + instance['InstanceId'])

# STEP 2b: Check if there are any tags in the selected instance
    # IMPORTANT: If there is no tag and the code doesn't
    # evaluate that, the code will crash
        if areThereEC2Tags in instance:

            # STEP 2c: assign the length of how many tags an instance is using
            len_tags = len(instance['Tags'])

# STEP 2d: iterate through all the tags in the instance
            for tags in instance["Tags"]:
                # DEBUGGING: this will print out the tag KEY and VALUE
                print('tag key: ' + tags['Key'] +
                      ' tag value: ' + tags['Value'])

# STEP 2e: comparison to know whether the Key is Name
                if (tags['Key'] == 'Name'):
                    # STEP 2.1e: append the key and the value in the global variables
                    ec2_tag_key.append(tags['Key'])
                    ec2_tag_value.append(tags['Value'])
                    # DEBUGGING: this will print out the NAME VALUE of the instance
                    print('\tYY - ec2 tag - key: ' +
                          ec2_tag_key[x] + ' value: ' + ec2_tag_value[x])
                    break

# STEP 2f: if the code has found a tag with key Name,
    # create one tag with Key Name and Value Empty.
    # IMPORTANT: If there is no name tag there will be a logical
    # error since we're assigning Name tag from EC2 to the NICs.
                elif (d >= len_tags-1):
                    # DEBUGGING: just making sure to print out that
                    # instance does not have a Name tag
                    print('d is last and no name tag for ec2 instance')
# STEP 2.1f: create a new tag which key is Name and value is blank
                    ec2_tag_key.append('Name')
                    ec2_tag_value.append('')
                    # DEBUGGING: this will print out the NAME VALUE of the instance
                    print('\tXX - ec2 tag - key: ' +
                          ec2_tag_key[x] + ' value: ' + ec2_tag_value[x])
                print('\n')

                d += 1  # increase the count for comparison purpose

            d = 0  # note: "what is this doing here?"

### PART 3 ###

# STEP 3a: get all the NICs associated with an instances and store them in a in variable
        for nic in instance["NetworkInterfaces"]:
            eni_ids.append(nic['NetworkInterfaceId'])
            print('eni id: ' + eni_ids[y])

# STEP 3b: describe network interfaces and store its value in a variable
    # we are doing this so that we can assign a tag to the NIC
            ec2_eni = client.describe_network_interfaces(
                NetworkInterfaceIds=[
                    eni_ids[y]
                ],
            )

# STEP 3c: iterate through the network interfaces description
    # stored in the previous step
            for networkinterfaces in ec2_eni['NetworkInterfaces']:

                # STEP 3d: check whether the NIC has more than one tag
                # IMPORTANT: this would make ...
                if (len(networkinterfaces['TagSet']) > 0):
                    # STEP 3d-1: we loop through the NICs tags
                    for nic_tags in networkinterfaces['TagSet']:

                        # STEP 3d-2: comparison to know whether the Key is Name
                        if (nic_tags['Key'] == 'Name'):

                            # STEP 3d-3: evaluating that the instance Name is not empty
                            if (ec2_tag_value[x] != ""):

                                # evaluating whether the NIC is not the same as the ec2 instance Name
                                if(nic_tags['Value'] != ec2_tag_value[x]):
                                    # invoking the create tag method to assign a name to the NIC based
                                        # based on EC2 name tag
                                    tag_class.create_tag(
                                        client, eni_ids[y], ec2_tag_key[x], ec2_tag_value[x])
                            # STEP 3d-3: else if the instance has an empty name tag
                            else:
                                # invoking the create tag method to assign an empty name to the NIC
                                tag_class.create_tag(
                                    client, eni_ids[y], 'Name', '')
                # STEP 3e: if the NIC does not have any tag, then create one
                else:
                    
                    # STEP 3e-1: evaluating that the instance Name is not empty
                    if (ec2_tag_value[x] != ""):
                        # invoking the create tag method to assign a name to the NIC based
                                        # based on EC2 name tag
                        tag_class.create_tag(
                            client, eni_ids[y], ec2_tag_key[x], ec2_tag_value[x])
                    # STEP 3e-2: else if the instance has an empty name tag
                    else:
                        # invoking the create tag method to assign an empty name to the NIC
                        tag_class.create_tag(
                            client, eni_ids[y], 'Name', '')

            y += 1  # increase the count to go to the other NIC

        x += 1  # increase the count to go to the other instance
        print(x)
        print('\n')
