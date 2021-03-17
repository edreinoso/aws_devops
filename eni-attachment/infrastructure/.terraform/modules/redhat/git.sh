echo "Welcome to the Infrastrucutre Autopushing"


# deleting larger files
cd /Users/ELCHOCO/AWS/aws-infra-template/standard-1/compute-stack/
rm -rf .terraform
cd /Users/ELCHOCO/AWS/aws-infra-template/standard-1/network-stack/
rm -rf .terraform
cd /Users/ELCHOCO/AWS/aws-infra-template/standard-2/
rm -rf .terraform

# pushing to the changes to the repo
cd /Users/ELCHOCO/AWS/aws-infra-template/
read -p "Enter a commit message: " message
git add .
git commit -m "$message"
git push