import boto3
from createTag import createTag

# STEP 1c: declare global variables
ec2_tag_value = []              # variable for storing name values from ec2
ec2_tag_key = []                # note: "have to know what this is actually for."
eni_ids = []                    # variable for storing the NIC ids from each EC2 instance.


def lambda_handler(event, context):
    # Documentation: https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html#client
    client = boto3.client('ec2')


    # Declare looper variables
    instance_loop = 0           # looper variable: for going through a series of instances
    instance_tag_loop = 0       # looper variable: for going through all the tags in the instance.
    eni_loop = 0                # looper variable: for going through all the NICs in a particular instance
    
    # variable for invoking method that would assign name values to NICs
    tag_class = createTag()     # variable for invoking method that would assign name values to NICs
    areThereEC2Tags = 'Tags'    # variable for error handling
    len_tags = 0                # variable for determining the exact number of NICs that an instance has

    # Make use of the describe_instance() method from the ec2 client variable
    ec2 = client.describe_instances()
