output "region" {
  value = var.region
}

output "cloudrock_project2" {
  value = var.cloudrock_project2
}

output "cloudrock-vpc_id" {
  value = aws_vpc.cloudrock-vpc.id 
}

output "public-subnet1_id" {
  value = aws_subnet.web-public-subnet1-cidr_block.id
}

output "public-subnet2_id" {
  value = aws_subnet.web-public-subnet2-cidr_block.id
}

output "app-private-subnet1_id" {
  value = aws_subnet.app-private-subnet1-cidr_block.id
}

output "app-private-subnet2_id" {
  value = aws_subnet.app-private-subnet2-cidr_block.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.igw-cloud-vpc
}

output "web-public-route_id" {
  value = aws_route_table.web-public-route.id
}

output "app-private-route_id" {
  value = aws_route_table.app-private-route.id
}

output "web-sub1-pub-rtba_id" {
  value = aws_route_table_association.web-sub1-pub-rtba.id
}

output "web-sub2-pub-rtba_id" {
  value = aws_route_table_association.web-sub2-pub-rtba.id
}

output "app-sub1-priv-rtba_id" {
  value = aws_route_table_association.app-sub1-priv-rtba.id
}

output "app-sub2-priv-rtba_id" {
  value = aws_route_table_association.app-sub2-priv-rtba.id
}

output "igw-pub-rtba_id" {
  value = aws_route_table_association.igw-pub-rtba.id
}

output "cloud-eip_id" {
  value = aws_eip.cloud-eip
}

output "cloud-nat-gw_id" {
  value = aws_nat_gateway.cloud-nat-gw.id
}

output "app-private-route1_id" {
  value = aws_route_table.app-private-route1.id
}

output "cloudrock-sg1_id" {
  value = aws_security_group.cloudrock-sg1.id
}

output "cloudrock-sg2_id" {
  value = aws_security_group.cloudrock-sg2.id
}

output "cloudrock-sg3_id" {
  value = aws_security_group.cloudrock-sg3.id
}

output "server1_id" {
  value = aws_instance.server1 [0].id
}

output "web1_id" {
  value = aws_instance.web1 [0].id
}

output "cloudrock-sg4_id" {
  value = aws_security_group.cloudrock-sg4.id
}

output "database-subnet-group" {
  value = aws_db_subnet_group.database-subnet-group.id
}

output "cloud-database-instance" {
  value = aws_db_instance.cloud-database-instance.id
}

