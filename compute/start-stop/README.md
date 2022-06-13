# Start Stop RDS/EC2

### Goal

Start and stop EC2 and RDS instances for cost optimization.

### Motivation

There are times where EC2 or RDS instance might be running with idle CPU or Memory that is being used. Even though AWS charges per second use, there can be a difference of thousands depending on the instance type that is used. Hence, this automation piece turns off/on EC2 or RDS instances at the desired time.

### Directory structure:

The repo is dividided into three parts:
- Nodejs code for starting and stopping RDS instances using AWS SDK

- Python start and stop EC2 instances using library Boto3 

- Python start and stop RDS instances using library Boto3 

All these functions need to work with CloudWatch Events to be triggered at the desired time.