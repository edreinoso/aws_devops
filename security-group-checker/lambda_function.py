import boto3

# these variables are going to be changing
# they can even transformed into events
wide_open = '0.0.0.0/0'

# exception handling variables
exFromPort = 'FromPort'
exToPort = 'ToPort'
region = 'us-east-2'

client = boto3.client('ec2', region_name=region)

# data will be sent to S3 for analysis
bucket_name = "security-groups-checker"
file_name = "prdSecurityGroups.txt"
lambda_path = "/tmp/" + file_name
s3_path = "/" + file_name


def lambda_handler(event, context):
    response = client.describe_security_groups()

    # variables required to delete rule
    groupId = ''
    groupName = ''
    fromPort = ''
    toPort = ''
    ipProtocol = ''
    finalString = ''
    # groupName = ''

    for sg in response["SecurityGroups"]:
        # grab these variables so that they're sent to the revoke security group access
        groupId = sg['GroupId']
        groupName = sg['GroupName']

        for ip in sg['IpPermissions']:
            # there has to be an exception for security groups that don't have ports.
            if exFromPort in ip:
                fromPort = ip['FromPort']
                ipProtocol = ip['IpProtocol']
                toPort = ip['ToPort']
                for cidr in ip['IpRanges']:
                    print('\t' + ' - Cidr: ' + cidr['CidrIp'])
                    if cidr['CidrIp'] == wide_open:
                            string = writeToFile(groupId, groupName, fromPort, toPort, ipProtocol, wide_open)
                            finalString += string
                    #

    # sending data to S3
    encoded_string = finalString.encode("utf-8")
    s3 = boto3.resource("s3")
    s3.Bucket(bucket_name).put_object(Key=s3_path, Body=encoded_string)

    return ("Completed")


def writeToFile(groupId, groupName, fromPort, toPort, ipProtocol, wide_open):
    string = 'GroupId: ' + groupId + '\nGroupName: ' + groupName + '\nFromPort: ' + \
        str(fromPort) + '\nToPort: ' + str(toPort) + '\nIpProtocol: ' + \
        ipProtocol + '\nRules: ' + wide_open + '\n\n'
    return string
