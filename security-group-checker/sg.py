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
file_name = "securityGroups.txt"
lambda_path = "/tmp/" + file_name
s3_path = "/" + file_name

def lambda_handler(event, context):
    #event['region']
    response = client.describe_security_groups(
        Filters=[
            {
                'Name': 'vpc-id',
                # this should just be a variable that's passed with the event
                'Values': [event['dev']]
                
            },
        ]
    )

    print('\n')

    # variables required to delete rule
    groupId = ''
    groupName = ''
    fromPort = ''
    toPort = ''
    ipProtocol = ''
    # groupName = ''

    for sg in response["SecurityGroups"]:
        # grab these variables so that they're sent to the revoke security group access
        groupId = sg['GroupId']
        groupName = sg['GroupName']

        print(sg)
        # print('Group Id: ' + groupId + '\t' + ' Group Name: ' + groupName)
        print('Group Id: ' + groupId)
        for ip in sg['IpPermissions']:
            # there has to be an exception for security groups that don't have ports.
            if exFromPort in ip:
                # print('---> yes, its available')
                fromPort = ip['FromPort']
                ipProtocol = ip['IpProtocol']
                toPort = ip['ToPort']
                print('From Port: ' + str(fromPort) +
                      '\t' + ' To Port: ' + str(toPort))
            for cidr in ip['IpRanges']:
                if cidr['CidrIp'] == wide_open:
                    print('Hello World: close below security group')
                    string = writeToFile(groupId, groupName, fromPort, toPort, ipProtocol, wide_open)
                    # writeToFile(groupId, fromPort, toPort, ipProtocol, wide_open)
                    # deleteRule(response, groupId, fromPort, toPort, ipProtocol, wide_open)
                print('\t' + ' - Cidr: ' + cidr['CidrIp'])
        print('\n')

    print('\n')
    
    # sending data to S3
    encoded_string = string.encode("utf-8")
    s3 = boto3.resource("s3")
    s3.Bucket(bucket_name).put_object(Key=s3_path, Body=encoded_string)
    
    return ("Completed")


def writeToFile(groupId, groupName, fromPort, toPort, ipProtocol, wide_open):
    string='GroupId: ' + groupId + '\nGroupName: ' + groupName + '\nFromPort: ' + str(fromPort) + '\nToPort: ' + str(toPort) + '\nIpProtocol: ' + ipProtocol + '\nRules: ' + wide_open + '\n'
    return string

def deleteRule(response, groupId, fromPort, toPort, ipProtocol, wide_open):
    response = client.revoke_security_group_ingress(
        GroupId=groupId,
        IpPermissions=[
            {
                'FromPort': fromPort,
                'ToPort': toPort,
                'IpProtocol': ipProtocol,
                'IpRanges': [{'CidrIp': wide_open}]
            },
        ],
    )
