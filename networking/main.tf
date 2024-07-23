resource "aws_vpc" "Prod-VPC" {
  cidr_block = var.vpc-cidr
  tags = {
    Name = "${terraform.workspace}-${var.vpc-tag}"
  }
}

resource "aws_subnet" "NAT-ALB-PublicSubnets" {
  vpc_id            = aws_vpc.Prod-VPC.id
  count             = length(var.availability_zone)
  availability_zone = element(var.availability_zone, count.index)
  cidr_block        = element(var.Subnet_1_2_cidr, count.index)
  tags = {
    Name        = "${terraform.workspace}-${element(var.subnet_1_2_tags, count.index)}"
    Environment = "Prod"
  }
}

resource "aws_subnet" "Webserver-subnets" {
  vpc_id            = aws_vpc.Prod-VPC.id
  count             = length(var.availability_zone)
  availability_zone = element(var.availability_zone, count.index)
  cidr_block        = element(var.Webserver-subnet-cidr, count.index)
  tags = {
    Name        = "${terraform.workspace}-${var.webservers-tags[count.index]}"
    Environment = "Prod"
  }
}

resource "aws_subnet" "Appserver-subnets" {
  vpc_id            = aws_vpc.Prod-VPC.id
  count             = length(var.availability_zone)
  availability_zone = element(var.availability_zone, count.index)
  cidr_block        = element(var.appserver-cidr, count.index)
  tags = {
    Name        = "${terraform.workspace}-${var.appserver-tags[count.index]}"
    Environment = "Prod"
  }
}

resource "aws_subnet" "database-subnets" {
  vpc_id            = aws_vpc.Prod-VPC.id
  count             = length(var.availability_zone)
  availability_zone = element(var.availability_zone, count.index)
  cidr_block        = element(var.database-subnet-cidr, count.index)
  tags = {
    Name        = "${terraform.workspace}-${var.database-subnet-tags[count.index]}"
    Environment = "Prod"
  }
}

resource "aws_route_table" "project-RT" {
  count  = length(var.subnet_rt_associations)
  vpc_id = aws_vpc.Prod-VPC.id
  tags = {
    Name        = "${terraform.workspace}-${var.route_table_tags[count.index]}"
    Environment = "Prod"
  }
}

resource "aws_internet_gateway" "Prod-VPC-IGW" {
  vpc_id = aws_vpc.Prod-VPC.id

  tags = {
    Name = "${terraform.workspace}-NAT-ALB-subnet1-igw"
  }
}

resource "aws_route" "internet-route" {
  count                  = length(var.subnet_rt_associations)
  route_table_id         = aws_route_table.project-RT[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.Prod-VPC-IGW.id
}

resource "aws_eip" "nat-eip" {
  count = length(var.availability_zone)

  domain = "vpc"
}

resource "aws_nat_gateway" "App-subnet-nat-gateway" {
  count       = length(var.availability_zone)
  subnet_id   = aws_subnet.Appserver-subnets[count.index].id
  allocation_id = aws_eip.nat-eip[count.index].id

  depends_on = [
    aws_subnet.Appserver-subnets,
    aws_eip.nat-eip,
  ]
}

resource "aws_nat_gateway" "database-subnet-nat-gateway" {
  count       = length(var.availability_zone)
  subnet_id   = aws_subnet.database-subnets[count.index].id
  allocation_id = aws_eip.nat-eip[count.index].id

  depends_on = [
    aws_subnet.database-subnets,
    aws_eip.nat-eip,
  ]
}

resource "aws_route" "App-nat-gateway-route" {
  count                  = length(var.availability_zone)
  route_table_id         = aws_route_table.project-RT[count.index].id
  nat_gateway_id         = aws_nat_gateway.App-subnet-nat-gateway[count.index].id
  destination_cidr_block = "0.0.0.0/0"

  depends_on = [
    aws_route_table.project-RT,
    aws_nat_gateway.App-subnet-nat-gateway,
  ]
}

resource "aws_route" "database-nat-gateway-route" {
  count                  = length(var.availability_zone)
  route_table_id         = aws_route_table.project-RT[count.index].id
  nat_gateway_id         = aws_nat_gateway.database-subnet-nat-gateway[count.index].id
  destination_cidr_block = "0.0.0.0/0"

  depends_on = [
    aws_route_table.project-RT,
    aws_nat_gateway.database-subnet-nat-gateway,
  ]
}

resource "aws_route_table_association" "subnet-rt-association" {
  for_each = var.subnet_rt_associations

  subnet_id      = each.key
  route_table_id = aws_route_table.project-RT[each.value].id

  depends_on = [
    aws_route_table.project-RT,
    aws_subnet.NAT-ALB-PublicSubnets,
    aws_subnet.Webserver-subnets,
    aws_subnet.Appserver-subnets,
    aws_subnet.database-subnets,
    aws_internet_gateway.Prod-VPC-IGW,
    aws_nat_gateway.App-subnet-nat-gateway,
    aws_nat_gateway.database-subnet-nat-gateway,
    aws_eip.nat-eip,
  ]
}
