# configure aws provider
provider "aws" {
    region  = var.region
    
}

# create vpc
module "module-vpc" {
  source                                    = "../modules/"
  region                                    = var.region
  cloudrock_project2                        = var.cloudrock_project2
  cloudrock-vpc                             = var.cloudrock-vpc
  web-public-subnet1-cidr_block             = var.web-public-subnet1-cidr_block
  web-public-subnet2-cidr_block             = var.web-public-subnet2-cidr_block
  app-private-subnet1-cidr_block            = var.app-private-subnet1-cidr_block
  app-private-subnet2-cidr_block            = var.app-private-subnet2-cidr_block
  instance_tenancy                          = var.instance_tenancy 
  instance_type1                            = var.instance_type1
  instance1_count                           = var.instance1_count
  aws_instance-server1                      = var.aws_instance-server1
  instance_type2                            = var.instance_type2
  cloudrock-sg3                             = var.cloudrock-sg3
  cloudrock-sg2                             = var.cloudrock-sg2
  cloudrock-sg1                             = var.cloudrock-sg1
  aws_instance-web1                         = var.aws_instance-server1
  aws_db_subnet_group-database-subnet-group = var.aws_db_subnet_group-database-subnet-group
  cloud-database-instance-class             = var.cloud-database-instance-class
  instance_count                            = var.instance1_count
  cloud-rds-instance-identifier             = var.cloud-rds-instance-identifier
  aws_security_group-cloudrock-sg4          = var.aws_security_group-cloudrock-sg4
  
}

