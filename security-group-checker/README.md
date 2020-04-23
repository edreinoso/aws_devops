# Security Group Checker

### Goal

Close all open rules in the security groups for better compliance.

### Motivation

Handling security groups and their rules can be a full time job. It is always best practice to open the necessary ports and the necessary range that the security group will actually use. One time I had to manually close 0.0.0.0/0 in twenty security groups. So I thought that it would be a great opportunity for automating this task with a lambda function. The function will look into all your security groups and check which rules are opened that need to be closed.