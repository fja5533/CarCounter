/* Main VPC */
resource "aws_vpc" "carcountr_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "carcountr_vpc"
  }
}

/* Internet Gateway for Public Subnet */
resource "aws_internet_gateway" "carcountr_igw" {
  vpc_id = aws_vpc.carcountr_vpc.id
  tags = {
    Name = "default"
  }
}

/* Public Subnet */
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.carcountr_vpc.id
  cidr_block              = "10.0.0.0/26"
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}

/* Public Route Table for Public Subnet */
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.carcountr_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.carcountr_igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

/* Attatch Public Route Table to Public Subnet */
resource "aws_route_table_association" "public_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_security_group" "ssh-allowed" {
  vpc_id = aws_vpc.carcountr_vpc.id

  egress = [
    {
      cidr_blocks      = [ "0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    },
  {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 80
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 80
  },
  {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 443
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 443
  }
  ]
 ingress                = [
   {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 22
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 22
  },
  {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 80
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 80
  },
  {
     cidr_blocks      = [ "0.0.0.0/0", ]
     description      = ""
     from_port        = 443
     ipv6_cidr_blocks = []
     prefix_list_ids  = []
     protocol         = "tcp"
     security_groups  = []
     self             = false
     to_port          = 443
  }
  ]
  tags = {
    Name = "ssh-allowed"
  }
}