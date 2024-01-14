# AWS Data Engineer Pipeline Project

# Setup
Prehequisites
1. Terraform
2. AWS account

Clone the repo and go to project folder
```bash
git clone https://github.com/lucas-placido/aws-de-project/tree/main
cd aws-de-project
```
Create aws credentials file in the following folder for terraform and then fill with the region and access keys


C:/Users/%username%/.aws/credentials.txt
```
[default]
region = us-east-1
aws_access_key_id = your_access_key
aws_secret_access_key = your_secret_access_key
```

Execute gen-key-pair to ssh into ec2 instance
``` bash
./Terraform/ec2/gen-key-pair.cmd
```

Create aws infrastructure with terraform
``` bash
terraform init
terraform apply --auto-approve
````