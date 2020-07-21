alias deployinstances='cd /Users/elchoco/aws/aws_devops/ebs-available/terraform/ec2 && terraform apply -auto-approve  && cd /Users/elchoco/aws/aws_devops/ebs-available/terraform/volumes  && terraform apply -auto-approve'

alias destroyinstances='cd /Users/elchoco/aws/aws_devops/ebs-available/terraform/ec2 && terraform destroy -auto-approve && cd /Users/elchoco/aws/aws_devops/ebs-available/terraform/volumes && terraform destroy -auto-approve'

alias devdeploy='cd /Users/elchoco/aws/aws_devops/ebs-available/lambda && zip dev_lambda_function.zip lambda_function.py && terraform apply -auto-approve'

terraform init && terraform workspace select dev && cd /Users/elchoco/aws/aws_devops/ebs-available/terraform/volumes && terraform init && terraform workspace select dev && deployinstances

#pushing to repo
rm -rf /Users/elchoco/aws/aws_devops/ebs-available/terraform/ec2/.terraform
rm -rf /Users/elchoco/aws/aws_devops/ebs-available/terraform/volumes/.terraform
git add .
&& git commit -m 
&& git push