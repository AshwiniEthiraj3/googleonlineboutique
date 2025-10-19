resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr_vpc
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name= "${var.cluster_name}-vpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
   tags = {
    Name= "${var.cluster_name}-igw"
   }
}

resource "aws_subnet" "public_subnet" {
  count = length(var.cidr_publicsubnet)
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.cidr_publicsubnet[count.index]
  availability_zone = var.availability_zone[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name= "${var.cluster_name}-public-${count.index+1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_route_table" "pubrt" {
vpc_id = aws_vpc.myvpc.id
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
}
tags ={
    Name= "${var.cluster_name}-public-rt"
} 
}

resource "aws_route_table_association" "public" {
  count = length(var.cidr_publicsubnet)
  subnet_id = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.pubrt.id
}


resource "aws_subnet" "private_subnet" {
  count = length(var.cidr_privatesubnet)
  vpc_id = aws_vpc.myvpc.id
  cidr_block = var.cidr_privatesubnet[count.index]
  availability_zone = var.availability_zone[count.index]

  tags = {
    Name= "${var.cluster_name}-private-${count.index+1}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_route_table" "pvtrt" {
    count = length(var.cidr_privatesubnet)
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.mynat[count.index].id
  }
  tags = {
    Name="${var.cluster_name}-pvtrt-${count.index+1}"
  }
}

resource "aws_route_table_association" "private" {
  count = length(var.cidr_privatesubnet)
  subnet_id = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.pvtrt[count.index].id
}

resource "aws_eip" "nat" {
  count  = length(var.cidr_publicsubnet)
  domain = "vpc"
  tags = {
    Name = "${var.cluster_name}-eip-${count.index + 1}"
  }
}


resource "aws_nat_gateway" "mynat" {
    count = length(var.cidr_publicsubnet)
    allocation_id = aws_eip.nat[count.index].id
  subnet_id = aws_subnet.public_subnet[count.index].id
  tags = {
    Name="${var.cluster_name}-nat-${count.index+1}"
  }
}