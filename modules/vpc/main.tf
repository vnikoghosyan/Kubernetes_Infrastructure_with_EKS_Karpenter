resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}-vpc"
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zones[count.index]
  tags = {
    Name = "${var.name}-public-${count.index}"
  }
}

# resource "aws_subnet" "public_subnets" {
#   count                   = var.public_subnet_count
#   vpc_id                  = aws_vpc.eks_vpc.id
#   cidr_block              = element(var.public_subnet_cidrs, count.index)
#   map_public_ip_on_launch = true
#   availability_zone       = element(var.availability_zones, count.index)
#   tags = {
#     Name = "${var.name}-public-${count.index}"
#   }
# }

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.name}-private-${count.index}"
  }
}

# resource "aws_subnet" "private_subnets" {
#   count             = var.private_subnet_count
#   vpc_id            = aws_vpc.eks_vpc.id
#   cidr_block        = element(var.private_subnet_cidrs, count.index)
#   availability_zone = element(var.availability_zones, count.index)
#   tags = {
#     Name = "${var.name}-private-${count.index}"
#   }
# }