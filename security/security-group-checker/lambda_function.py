import boto3

# these variables are going to be changing
# they can even transformed into events
open_rules = '0.0.0.0/0'

# exception handling variables
exFromPort = 'FromPort'
exToPort = 'ToPort'
region = 'us-east-2'

# data will be sent to S3 for analysis
bucket_name = "security-group-checker"
file_name = "security_groups_test.txt"
lambda_path = "/tmp/" + file_name
s3_path = "/" + file_name

client = boto3.client('ec2')


def lambda_handler(event, context):
    response = client.describe_security_groups(
        # specify which vpc you want the function to run - OPTIONAL
        # Filters=[
        #     {
        #         'Name': 'vpc-id',
        #         'Values': [
        #             'vpc-00f68bf34b9a815fd',
        #         ]
        #     },
        # ],
    )

    # variables required to delete rule
    groupId = ''
    groupName = ''
    fromPort = ''
    toPort = ''
    ipProtocol = ''
    finalString = ''

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
                    # identifying which rules contain a open_rules IP range
                    if cidr['CidrIp'] == open_rules:
                        # logging the rule that will be deleted
                        string = writeToFile(
                            groupId, groupName, fromPort, toPort, ipProtocol, open_rules)
                        finalString += string
                        # delete the rule
                        deleteRule(cidr['CidrIp'], groupId, ipProtocol,
                                   fromPort, toPort)

    # sending data to S3
    encoded_string = finalString.encode("utf-8")
    s3 = boto3.resource("s3")
    s3.Bucket(bucket_name).put_object(Key=s3_path, Body=encoded_string)

    return ("Completed")

# function to delete wide open rules
# this is called from main method
def deleteRule(cidrIp, groupId, ipProtocol, fromPort, toPort):
    client.revoke_security_group_ingress(
        CidrIp=cidrIp,
        GroupId=groupId,
        IpProtocol=ipProtocol,
        FromPort=fromPort,
        ToPort=toPort
    )

# function to write to a file locally once
# the open rules have been identified
def writeToFile(groupId, groupName, fromPort, toPort, ipProtocol, open_rules):
    string = 'GroupId: ' + groupId + '\nGroupName: ' + groupName + '\nFromPort: ' + \
        str(fromPort) + '\nToPort: ' + str(toPort) + '\nIpProtocol: ' + \
        ipProtocol + '\nRules: ' + open_rules + '\n\n'
    return string
