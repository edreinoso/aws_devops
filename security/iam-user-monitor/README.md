# IAM User Monitor

### Goal
Report the user console login in the AWS account.

### Motivation
One of the challenges I faced as Cloud Engineer was reporting the accurate number of active users who were constantly loging with their AWS users to the console.

AWS IAM provides this functionality, however it doesn't provide the capablities of sorting. Instead, it provides a list of users (which is in IAM Users tab) in alphabetical order without having the hability to sort by last sign in.

### Tech stack description
This automation piece is primarly composed by three parts.
1. DynamoDB creation: uses Terraform to create a NoSQL database to put all the records from users

2. IamUserMonitor: uses Python code and Boto3 to get all the IAM users information, and put these into the DDB table.

3. SESUSerMonitor: uses Python and Boto3 to pull the data from the DynamoDB and parse it in a table email template, sorted by users who last sig in.

### Directory Structure
Directories are divided within the main three parts described before.

- dynamodb-table: terraform code to create a dynamodb table, setting TTL on each time to 7 days.

- IamUserMonitoring: runs the main code to get and put users into the DDB table using Python and Boto3 (IAM and DDB properties)

- SESUserMonitoring: runs few minutes after the first fuction. It pulls the data using Python and Boto3 from the DDB table and parses in an email template to send it to the Cloud admin using SES.