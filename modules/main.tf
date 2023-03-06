terraform {
}

# Create a VPC
resource "aws_vpc" "cloudrock-vpc" {
  cidr_block           = var.cloudrock-vpc
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.cloudrock_project2}"
  }
}


# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}


resource "aws_subnet" "web-public-subnet1-cidr_block" {
  vpc_id                  = aws_vpc.cloudrock-vpc.id
  cidr_block              = var.web-public-subnet1-cidr_block
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "web-public-subnet1"
  }
}

resource "aws_subnet" "web-public-subnet2-cidr_block" {
  vpc_id                  = aws_vpc.cloudrock-vpc.id
  cidr_block              = var.web-public-subnet2-cidr_block
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "web-public-subnet2"
  }
}

# Create 2 private subnets
resource "aws_subnet" "app-private-subnet1-cidr_block" {
  vpc_id                  = aws_vpc.cloudrock-vpc.id
  cidr_block              = var.app-private-subnet1-cidr_block
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "app-private-subnet1"
  }
}

resource "aws_subnet" "app-private-subnet2-cidr_block" {
  vpc_id                  = aws_vpc.cloudrock-vpc.id
  cidr_block              = var.app-private-subnet2-cidr_block
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "app-private-subnet2"
  }
}

# Create public route table
resource "aws_route_table" "web-public-route" {
  vpc_id = aws_vpc.cloudrock-vpc.id

  tags = {
    Name = "web-public-route"
  }
}

# Create private route table
resource "aws_route_table" "app-private-route" {
  vpc_id = aws_vpc.cloudrock-vpc.id

  tags = {
    Name = "app-private-route"
  }
}

# Route table association public
resource "aws_route_table_association" "web-sub1-pub-rtba" {
  subnet_id      = aws_subnet.web-public-subnet1-cidr_block.id
  route_table_id = aws_route_table.web-public-route.id
}

resource "aws_route_table_association" "web-sub2-pub-rtba" {
  subnet_id      = aws_subnet.web-public-subnet2-cidr_block.id
  route_table_id = aws_route_table.web-public-route.id
}

# Route table association private
resource "aws_route_table_association" "app-sub1-priv-rtba" {
  subnet_id      = aws_subnet.app-private-subnet1-cidr_block.id
  route_table_id = aws_route_table.app-private-route.id
}

resource "aws_route_table_association" "app-sub2-priv-rtba" {
  subnet_id      = aws_subnet.app-private-subnet2-cidr_block.id
  route_table_id = aws_route_table.app-private-route.id
}

# Create internet gateway
resource "aws_internet_gateway" "igw-cloud-vpc" {
  vpc_id = aws_vpc.cloudrock-vpc.id

  tags = {
    Name = "igw-cloud-vpc"
  }
}

# Internet Gateway and public Route table association
resource "aws_route_table_association" "igw-pub-rtba" {
  gateway_id     = aws_internet_gateway.igw-cloud-vpc.id
  route_table_id = aws_route_table.web-public-route.id
  #destination_cidr_block = var.aws_route-Test-pub-route-table
}


# Create EIP
resource "aws_eip" "cloud-eip" {
  vpc = true

  tags = {
    Name = "cloud-eip"
  }
}

# Create a NAT Gateway in Public Subnet association
resource "aws_nat_gateway" "cloud-nat-gw" {
  allocation_id = aws_eip.cloud-eip.id
  subnet_id     = aws_subnet.web-public-subnet1-cidr_block.id

  tags = {
    Name = "cloud-nat-gw"
  }
}

# Associating a Private Route Table for the Nat Gateway!
resource "aws_route_table" "app-private-route1" {
  depends_on = [
    aws_nat_gateway.cloud-nat-gw
  ]

  vpc_id = aws_vpc.cloudrock-vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.cloud-nat-gw.id
  }

  tags = {
    Name = "Route Table for NAT Gateway"
  }

}

# Create security group
resource "aws_security_group" "cloudrock-sg1" {
  description = var.cloudrock-sg1
  vpc_id      = aws_vpc.cloudrock-vpc.id


  ingress {
    description = "ssh access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "cloudrock-sg2" {
  description = var.cloudrock-sg2
  vpc_id      = aws_vpc.cloudrock-vpc.id

  ingress {
    description = "ssh access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "cloudrock-sg3" {
  description = var.cloudrock-sg3

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


# Create  Public EC2 Instance 					
resource "aws_instance" "server1" {
  ami                         = var.aws_instance-server1
  instance_type               = var.instance_type1
  key_name                    = "Newsshkeypair"
  count                       = var.instance_count
  subnet_id                   = aws_subnet.web-public-subnet1-cidr_block.id
  associate_public_ip_address = true

  tags = {
    name = "server1-${count.index + 1}"
  }
}

# Create  Private EC2 Instance 
resource "aws_instance" "web1" {
  ami                         = var.aws_instance-web1
  instance_type               = var.instance_type2
  key_name                    = "Newsshkeypair"
  count                       = var.instance_count
  vpc_security_group_ids      = [aws_security_group.cloudrock-sg1.id]
  subnet_id                   = aws_subnet.app-private-subnet1-cidr_block.id
  associate_public_ip_address = true

  tags = {
    name = "web1-${count.index + 1}"
  }
}

# create security group for the database
resource "aws_security_group" "cloudrock-sg4" {
  name        = "mysql database secgrp"
  description = var.aws_security_group-cloudrock-sg4
  vpc_id      = aws_vpc.cloudrock-vpc.id

  ingress {
    description     = "mysql access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.cloudrock-sg1.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mysql-database-secgrp"
  }
}



# create the subnet group for the rds instance
resource "aws_db_subnet_group" "database-subnet-group" {
  name        = "mysql-database-subnet"
  subnet_ids  = [aws_subnet.app-private-subnet1-cidr_block.id, aws_subnet.app-private-subnet2-cidr_block.id]
  description = var.aws_db_subnet_group-database-subnet-group

  tags = {
    Name = "mysql-database-subnet"
  }
}

# create the rds instance
resource "aws_db_instance" "cloud-database-instance" {
  engine                 = "mysql"
  engine_version         = "8.0.28"
  multi_az               = false
  identifier             = var.cloud-rds-instance-identifier
  username               = "clouddbs"
  password               = "clouddbs2023"
  instance_class         = var.cloud-database-instance-class #might need $ sign
  allocated_storage      = 200
  db_subnet_group_name   = aws_db_subnet_group.database-subnet-group.name
  vpc_security_group_ids = [aws_security_group.cloudrock-sg4.id]
  db_name                = "clouddatabase"
  skip_final_snapshot    = true
}