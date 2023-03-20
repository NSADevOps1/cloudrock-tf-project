To Use this Module to build your infrastructure you will need the files in the Modules Folder and the files in the Cloudrock-tf-project folder

#Create a complete VPC in eu-west-2
2 web-public subnets and 2 app-private subnets.
2 route tables one for public and one for the private subnets.
1 internet gateway
1 NAT gateway

Create an RDS using the MySQL with the latest version within the 5 engines. (Port 3306,80 and 22 are used).

Create 2 (t2.micro) Servers placed in public and 2 in the private subnets

Use the following commands to plan and apply the written code to pull values from dev.tfvars files.
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
terraform destroy -var-file="dev.tfvars"
