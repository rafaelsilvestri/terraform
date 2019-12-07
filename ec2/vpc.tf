# Create VPC/Subnet/Security Group/Network ACL

resource "aws_vpc" "tf-vpc" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy
  enable_dns_support   = var.dnsSupport
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = "tf-vpc"
  }
}

# Subnet
resource "aws_subnet" "public-subnet-1" {
  vpc_id                  = aws_vpc.tf-vpc.id
  cidr_block              = var.subnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone
  tags = {
    Name = "pub-subnet-1"
  }
}

# Security Group
resource "aws_security_group" "tf-sg-1" {
  vpc_id      = aws_vpc.tf-vpc.id
  name        = "Terraform Security Group"
  description = "Created by Terraform"

  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "VPC Security Group"
    Description = "VPC Security Group"
  }
}

# Create the Internet Gateway
resource "aws_internet_gateway" "tf-vpc_GW" {
  vpc_id = aws_vpc.tf-vpc.id
  tags = {
    Name = "My VPC Internet Gateway"
  }
}

# Create the Route Table
resource "aws_route_table" "tf-vpc_route_table" {
  vpc_id = aws_vpc.tf-vpc.id
  tags = {
    Name = "My VPC Route Table"
  }
}

# Create the Internet Access
resource "aws_route" "tf-vpc_internet_access" {
  route_table_id         = aws_route_table.tf-vpc_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.tf-vpc_GW.id
}

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "tf-vpc_association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.tf-vpc_route_table.id
}

# create VPC Network access control list
resource "aws_network_acl" "tf-vpc_Security_ACL" {
  vpc_id     = aws_vpc.tf-vpc.id
  subnet_ids = [aws_subnet.public-subnet-1.id]
  # allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22
    to_port    = 22
  }

  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80
    to_port    = 80
  }

  # allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }

  # allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22
    to_port    = 22
  }

  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80
    to_port    = 80
  }

  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
  tags = {
    Name = "My VPC ACL"
  }
}
