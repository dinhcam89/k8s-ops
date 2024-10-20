# Create Virtual Private Cloud (VPC)
resource "aws_vpc" "k8s-vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_hostnames = true
  tags = {
    Name = "${var.k8s_name}"
  }
}


# Create VPC Subnet 
resource "aws_subnet" "cluster_subnet" {
  vpc_id                  = aws_vpc.k8s-vpc.id
  cidr_block              = var.cidr_subnet
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.k8s_name}"
    Type = "Public"
  }
}

# Create Internet gateway 
resource "aws_internet_gateway" "k8s" {
  vpc_id = aws_vpc.k8s-vpc.id
  tags = {
    Name = "igw-${var.k8s_name}"
  }
}


# Create Route Table 
resource "aws_route_table" "k8s_rtb" {
  vpc_id = aws_vpc.k8s-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s.id
  }

  tags = {
    Name = "rt-${var.k8s_name}"
  }
}
# Create Route Table association for public VPC subnet 
resource "aws_route_table_association" "rta_cluster_subnet" {
  subnet_id      = aws_subnet.cluster_subnet.id
  route_table_id = aws_route_table.k8s_rtb.id
}