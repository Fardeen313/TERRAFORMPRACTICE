provider "aws" {
  profile = var.profile
  region  = var.region
}
data "aws_subnet" "name" {
  filter {
    name   = "tag:Name"
    values = ["subnet_1"]
  }
}
# Resouce VPC 
resource "aws_vpc" "name" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.Vpc
  }
}
# Resouce Internet Gateway #
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.name.id
  depends_on = [ aws_vpc.name ]
  tags = {
    Name = var.igw
  }
}
# Resouce Subnet-pub#
resource "aws_subnet" "pub" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = var.cidr-pub-sub
  availability_zone = var.pub-sub-az
  depends_on = [ aws_internet_gateway.igw ]
  tags = {
    Name = var.pub_sub
  }
}
# Resouce Route table #
resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.name.id
  depends_on = [ aws_vpc.name ]
  route {
    cidr_block = var.s_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = var.pub_rt
  }
}
# Resouce Route table association #
resource "aws_route_table_association" "pub" {
  route_table_id = aws_route_table.pubrt.id
  subnet_id      = aws_subnet.pub.id
  depends_on = [ aws_route_table.pubrt ]
}
resource "aws_route_table_association" "pub2" {
  route_table_id = aws_route_table.pubrt.id
  subnet_id      = data.aws_subnet.name.id
  depends_on     = [aws_route_table.pubrt]
}

   
# Resouce Subnet-pvt#
resource "aws_subnet" "pvt" {
  vpc_id            = aws_vpc.name.id
  cidr_block        = var.cidr-pvt-sub
  availability_zone = var.pvt-sub-az
  depends_on = [ aws_vpc.name ]
  tags = {
    Name = var.pvt_sub
  }
}
# Resouce EIP#
resource "aws_eip" "name" {
  domain = var.domain
  depends_on = [ aws_subnet.pub ]
  tags = {
    Name = var.eip
  }

}
# Resouce Nat gateway #
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.name.id
  subnet_id     = aws_subnet.pub.id
  depends_on = [aws_eip.name]
  tags = {
    Name = var.Ngw
  }

}
# Resouce Route table #
resource "aws_route_table" "pvtrt" {
  vpc_id = aws_vpc.name.id
  depends_on = [ aws_nat_gateway.ngw ]
  route {
    cidr_block     = var.s_cidr
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = var.pvt_rt
  }
}
# Resouce Route table association #
resource "aws_route_table_association" "pvt" {
  route_table_id = aws_route_table.pvtrt.id
  subnet_id      = aws_subnet.pvt.id
  depends_on = [ aws_route_table.pvtrt ]

}
# SG
resource "aws_security_group" "allow_common_ports" {
  name        = var.name_sg
  description = var.desc_sg
  vpc_id      = aws_vpc.name.id

  ingress {
    description = var.description_2
    from_port   = var.SSH
    to_port     = var.SSH
    protocol    = var.protocol
    cidr_blocks = [var.s_cidr]
  }

  ingress {
    description = var.description_1
    from_port   = var.HTTP
    to_port     = var.HTTP
    protocol    = var.protocol
    cidr_blocks = [var.s_cidr]
  }

  ingress {
    description = var.description_3
    from_port   = var.HTTPS
    to_port     = var.HTTPS
    protocol    = var.protocol
    cidr_blocks = [var.s_cidr]
  }

  ingress {
    description = var.description_4
    from_port   = var.MySQL
    to_port     = var.MySQL
    protocol    = var.protocol
    cidr_blocks = [var.s_cidr]
  }

  egress {
    description = var.description_5
    from_port   = var.egress_from_port
    to_port     = var.egress_to_port
    protocol    = var.egress_protocol
    cidr_blocks = [var.s_cidr]
  }

  tags = {
    Name = var.tag_sg
  }
}