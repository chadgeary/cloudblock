# vpc and gateway
resource "aws_vpc" "ph-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  tags = {
    Name = "ph-vpc"
  }
}

# internet gateway 
resource "aws_internet_gateway" "ph-gw" {
  vpc_id = aws_vpc.ph-vpc.id
  tags = {
    Name = "ph-gw"
  }
}

# public route table
resource "aws_route_table" "ph-pubrt" {
  vpc_id = aws_vpc.ph-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ph-gw.id
  }
  tags = {
    Name = "ph-pubrt"
  }
}

# public subnet
resource "aws_subnet" "ph-pubnet" {
  vpc_id            = aws_vpc.ph-vpc.id
  availability_zone = data.aws_availability_zones.ph-azs.names[var.aws_az]
  cidr_block        = var.pubnet_cidr
  tags = {
    Name = "ph-pubnet"
  }
  depends_on = [aws_internet_gateway.ph-gw]
}

# public route table associations
resource "aws_route_table_association" "rt-assoc-pubnet" {
  subnet_id      = aws_subnet.ph-pubnet.id
  route_table_id = aws_route_table.ph-pubrt.id
}
