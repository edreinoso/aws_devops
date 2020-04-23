# AWS Devops

![aws-devops](https://personal-website-assets.s3.amazonaws.com/Projects/aws_devops.png)

### Goal
Creating automation tools that would aid the management of an AWS environment

### Motivation
While I was working at Deloitte as a Cloud Engineer, there were many repetitive tasks that were done on a daily basis which took a lot of time. As a engineer, one my responsibilities was to automate these tasks so that we could focus on other priority activities. So I started using Python with Boto3 to create some automation pieces that would take control of AWS resources to carry these reptitive tasks.

### Use Cases
There are a lot of posibilities that can be expanded from using this concept. Among some of these, I highlight: 
- Elastic Block Storage EBS and Network Interface Card NIC name tag automation
  - This provides a name after the EC2 instance name

- Security groups open rules closure
  - This closes all open rules (0.0.0.0/0) that are in the security groups

- Snapshot copy to another region
  - This copies snapshots from one region to another as a disaster recovery solution

- Start and Stop of EC2 instances
  - This starts and stop the EC2 instance for cost optimization

- Deletion of unused EBS volume
  - This deletes the idle and unused EBS volumes for cost optimzation

- IAM user console login monitoring
  - This provides a Cloud admins an overview of users who have logged into their accounts

Howerver, these are only few of the endless capabilities that can be developed for easier AWS management

### Tech stack description
These functions are going to leverage several AWS to carry their job. AWS Lambda and AWS CloudWatch Events are among the biggest services used.

#### AWS Lambda

In order to deploy an AWS Lambda function, run these commands:
1. Zip python file where main code is located
```
zip function.zip lambda_function.py
```
2. Deploy function
```
aws lambda update-function-code --function-name $YOUR_FUNCTION  --zip-file fileb://function.zip
```
3. Invoke function
```
aws lambda invoke --function-name $YOUR_FUNCTION --payload '{ "name": "Ed" }' output.json
```

It is important to know that a lambda_function.py should have a **handler** which is supposed to be the main method recognize by lambda to execute commands.

For more information about how to create a function please refer to AWS documentation

https://docs.aws.amazon.com/lambda/latest/dg/getting-started-create-function.html

#### AWS CloudWatch
In order for these functions to run, there must be a trigger that is going to invoke them a certain time. CloudWatch events have the ability to invoke lambda functions that will execute their automation tasks in the environment.

For example, you might want to close open rules in your security groups on a daily bases for security compliance reasons. You can create an event that will invoke the **Security-group-checker** function every day at 9am to do this job.

For more information about how to create an event please refer to AWS documentation

https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/Create-CloudWatch-Events-Rule.html

### Directory structure
There are seven directories in this repo, each of them carrying a certain functionality. In each file, there's going to be:
- Main lambda_function.py handler
- Other class .py files to support the handler
- Other supporting files for the function to execute