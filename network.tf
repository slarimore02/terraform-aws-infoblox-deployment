# Create VPC and Subnets for Nios
resource "aws_network_interface" "first" {
  subnet_id       = var.create_networking ? aws_subnet.nios_mgmt[0].id : var.custom_subnet_ids[0]
  security_groups = [aws_security_group.nios_sg.id]
}
resource "aws_network_interface" "second" {
  subnet_id       = var.create_networking ? aws_subnet.nios_lan[0].id : var.custom_subnet_ids[1]
  security_groups = [aws_security_group.nios_sg.id]
}
resource "aws_eip" "mgmt" {
  count             = var.public_address ? 1 : 0
  vpc               = true
  network_interface = aws_network_interface.second.id
}
resource "aws_vpc" "nios" {
  count      = var.create_networking ? 1 : 0
  cidr_block = var.nios_cidr_block

  tags = {
    Name = "${var.name_prefix}-nios-vpc"
  }
}

resource "aws_subnet" "nios_mgmt" {
  count                   = var.create_networking ? 1 : 0
  vpc_id                  = aws_vpc.nios[0].id
  cidr_block              = cidrsubnet(aws_vpc.nios[0].cidr_block, 8, 231)
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = var.public_address ? true : false
  tags = {
    Name = "${var.name_prefix}-nios-mgmt-subnet-${data.aws_availability_zones.azs.names[0]}"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_subnet" "nios_lan" {
  count                   = var.create_networking ? 1 : 0
  vpc_id                  = aws_vpc.nios[0].id
  cidr_block              = cidrsubnet(aws_vpc.nios[0].cidr_block, 8, 232)
  availability_zone       = data.aws_availability_zones.azs.names[0]
  map_public_ip_on_launch = var.public_address ? true : false
  tags = {
    Name = "${var.name_prefix}-nios-lan-subnet-${data.aws_availability_zones.azs.names[0]}"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_internet_gateway" "nios" {
  count  = var.create_networking ? 1 : 0
  vpc_id = aws_vpc.nios[0].id
  tags = {
    Name = "${var.name_prefix}-nios-igw"
  }
}

resource "aws_route" "default_route" {
  count                  = var.create_networking ? 1 : 0
  route_table_id         = aws_vpc.nios[0].main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.nios[0].id
}