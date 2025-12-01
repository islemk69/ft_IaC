provider "aws" {
  region = "eu-north-1"
}

####################
#        SSH       #
####################

resource "aws_key_pair" "deployer_key" {
  key_name   = "cle-pour-terraform"
  public_key = file("${path.module}/my_tf_key.pub")
}

####################
#        VPC       #
####################

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "ft_iac_vpc"
  }
}

####################
#      GATEWAY     #
####################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "ft_itac_igw"
  }
}

####################
#      SUBNET      #
####################

resource "aws_subnet" "public_a" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-north-1a"
  map_public_ip_on_launch = true
  
  tags = { Name = "public_subnet_a" }
}

resource "aws_subnet" "public_b" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-north-1b"
  map_public_ip_on_launch = true
  
  tags = { Name = "public_subnet_b" }
}

resource "aws_subnet" "private_a" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-north-1a"
  
  tags = { Name = "private_subnet_a" }
}


resource "aws_subnet" "private_b" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-north-1b"

  
  tags = { Name = "private_subnet_b" }
}


####################
#   PUBLIC ROUTE   #
####################

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "public_route_table"}
}

resource "aws_route_table_association" "public_assoc_a" {
  subnet_id = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_b" {
  subnet_id = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

####################
#    NAT GATEWAY   #
####################

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public_a.id

  tags = { Name = "main_nat_gateway" }

  depends_on = [ aws_internet_gateway.igw ]
}

#####################
#   PRIVATE ROUTE   #
#####################

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = { Name = "private_route_table"}
}

resource "aws_route_table_association" "private_assoc_a" {
  subnet_id = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_b" {
  subnet_id = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt.id
}

output "vpc_id" {
  value = aws_vpc.main_vpc.id
}

#####################
#        AMI        #
#####################

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # ID du compte Canonical (Editeur officiel Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



# output "server_public_ip" {
#   value = aws_instance.test_server.public_ip
# }





# resource "aws_security_group" "allow_ssh" {
#   name        = "allow_ssh_traffic"
#   description = "Allow SSH inbound"

#   ingress {
#     description = "SSH from anywhere"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"] 
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_instance" "test_server" {
#   ami           = "ami-0fa91bc90632c73c9" 
#   instance_type = "t3.micro"              

#   key_name      = aws_key_pair.deployer_key.key_name
#   vpc_security_group_ids = [aws_security_group.allow_ssh.id]

#   tags = {
#     Name = "HelloWorld-Terraform"
#   }
# }
