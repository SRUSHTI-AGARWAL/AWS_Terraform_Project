#Private VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block       = var.cidr

}

#Public subnets
resource "aws_subnet" "demo_subnet1" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.0.0/26"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch= true

}


resource "aws_subnet" "demo_subnet2" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.0.64/26"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true
}
#---
# Internet gateway for Internet access
resource "aws_internet_gateway" "demo_ig" {
  vpc_id = aws_vpc.demo_vpc.id
}


# Private subnet to place private instance inside it
resource "aws_subnet" "demo_subnet_private" {
  vpc_id     = aws_vpc.demo_vpc.id
  cidr_block = "10.0.0.128/26"
  availability_zone = "ap-south-1c"
  map_public_ip_on_launch = true
}

resource "aws_eip" "nat_eip" {
#domain = "vpc"

depends_on = [aws_internet_gateway.demo_ig]
}
#NAT Gateway for Private subnet traffic , places inside a public subnet
resource "aws_nat_gateway" "demo_public_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.demo_subnet2.id
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.demo_ig]

}

#Security Group 
resource "aws_security_group" "demo_sg" {
  name        = "demosg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.demo_vpc.id

ingress {
  cidr_blocks         = ["10.0.0.0/24"]
  from_port         = 80
  protocol       = "tcp"
  to_port           = 80
}


egress{

  cidr_blocks       = ["0.0.0.0/0"]
  protocol       = "-1" # semantically equivalent to all ports
  from_port = 0
  to_port = 0
}
}

#Route table for Public subnets
resource "aws_route_table" "demo_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo_ig.id
  }
}

#Route Table for Private Subnets
resource "aws_route_table" "demo_prt"{
vpc_id = aws_vpc.demo_vpc.id

route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.demo_public_nat.id
  }
}
# Route table association to public subnets
resource "aws_route_table_association" "demo_rta1" {
  subnet_id      = aws_subnet.demo_subnet1.id
  route_table_id = aws_route_table.demo_rt.id
}

resource "aws_route_table_association" "demo_rta2" {
  subnet_id      = aws_subnet.demo_subnet2.id
  route_table_id = aws_route_table.demo_rt.id
}

# ----
#private route table association to private subnet
resource "aws_route_table_association" "demo_rt_private"{
route_table_id = aws_route_table.demo_prt.id
subnet_id = aws_subnet.demo_subnet_private.id

}
