provider "aws" {
  region = var.region
}

#建vpc，subnet(2个)，internet gateway，route table（rtb-associate）
resource "aws_vpc" "dop-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "dop-vpc"
  }
}

resource "aws_subnet" "dop-public-subnet-1" {
  vpc_id                  = aws_vpc.dop-vpc.id
  cidr_block              = var.subent_cidr_block_1
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone_1
  tags = {
    Name = "dop-public-subent-1"
  }
}

resource "aws_subnet" "dop-public-subnet-2" {
  vpc_id                  = aws_vpc.dop-vpc.id
  cidr_block              = var.subent_cidr_block_2
  map_public_ip_on_launch = "true"
  availability_zone       = var.availability_zone_2
  tags = {
    Name = "dop-public-subent-2"
  }
}

resource "aws_internet_gateway" "dop-igw" {
  vpc_id = aws_vpc.dop-vpc.id
  tags = {
    Name = "dop-igw"
  }
}

resource "aws_route_table" "dop-rt" {
  vpc_id = aws_vpc.dop-vpc.id
  route {
    #设置cidr_block为任意ip
    cidr_block = "0.0.0.0/0"
    #需要一个entry point用于与外部broweser access，所以需要设置这个gateway
    gateway_id = aws_internet_gateway.dop-igw.id
  }
  tags = {
    Name = "dop-rtb"
  }
}

#需要设置Subnet Associate，让subnet与route table连接起来
resource "aws_route_table_association" "dop-rta-public-subnet-1" {
  subnet_id      = aws_subnet.dop-public-subnet-1.id
  route_table_id = aws_route_table.dop-rt.id
}

resource "aws_route_table_association" "dop-rta-public-subnet-2" {
  subnet_id      = aws_subnet.dop-public-subnet-2.id
  route_table_id = aws_route_table.dop-rt.id
}


#创建instance
resource "aws_instance" "dop-server" {
  #先用一个固定的ami吧
  ami                    = "ami-0fe2bbc538d630d05"
  instance_type          = var.instance_type
  key_name               = "aws-key"
  vpc_security_group_ids = [aws_security_group.dop-sg.id]
  subnet_id              = aws_subnet.dop-public-subnet-1.id
  #这里用for循环，建3个instance，分别叫这3个名
  for_each = toset(var.tag_names)
  tags = {
    Name = "${each.key}"
  }
}

#我们想要ssh access这个vpc，需要设置security group，允许port 22和port 8080可以access
resource "aws_security_group" "dop-sg" {
  name        = "dop-sg"
  description = "SSH Access"
  vpc_id      = aws_vpc.dop-vpc.id
  #ssh access，用port 22
  ingress {
    description = "SHH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    #因为ansible instance会连接其他2个instance（jenkins-master和jenkins-slave）
    cidr_blocks = ["0.0.0.0/0"]
  }
  #外部网络连接，cidr_blocks=[0.0.0.0/0]是任何ip range，protocol=“-1”也是任意
  ingress {
    description = "Jenkins port"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #0:0:0:0:0:0:0:0/0, 8组十六进制，128位
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "dop-sg"
  }
}

#create eks cluster
module "eks-sg" {
  source = "./eks-sg"
  vpc_id = aws_vpc.dop-vpc.id
}

module "eks" {
  source     = "./eks"
  subnet_ids = [aws_subnet.dop-public-subnet-1.id, aws_subnet.dop-public-subnet-2.id]
  sg_ids     = module.eks-sg.security_group_public
}





