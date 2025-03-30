data "aws_availability_zones" "available" {}

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "main"
  }
}

resource "aws_internet_gateway_attachment" "igw_attachment" {
  vpc_id              = var.vpc_id
  internet_gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route_table" "eks_route_tables" {
  count  = length(var.private_subnet_ranges)
  vpc_id = var.vpc_id
  route {
    nat_gateway_id = aws_nat_gateway.nat_gws[count.index].id
    cidr_block     = "0.0.0.0/0"
  }

  tags = {
    Name = "eks-route-table-${count.index}",
  }
}

resource "aws_route_table" "public_route_tables" {
  count  = length(var.public_subnet_ranges)
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table-${count.index}",
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_ranges)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_tables[count.index].id
}

resource "aws_route_table_association" "eks_subnet_association" {
  count          = length(var.private_subnet_ranges)
  subnet_id      = aws_subnet.eks_private_subnets[count.index].id
  route_table_id = aws_route_table.eks_route_tables[count.index].id
}


resource "aws_nat_gateway" "nat_gws" {
  count = length(var.public_subnet_ranges)

  allocation_id = aws_eip.nat_gw_eips[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name                     = "nat-gw-${count.index}",
    "karpenter.sh/discovery" = "${var.cluster_name}"
  }
}

resource "aws_eip" "nat_gw_eips" {
  count = length(var.private_subnet_ranges)

  tags = {
    Name                     = "eip-nat-gw-${count.index}",
    "karpenter.sh/discovery" = "${var.cluster_name}"
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_ranges)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_ranges[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "public-subnet-${count.index}",
  }
}

resource "aws_subnet" "eks_private_subnets" {
  count                   = length(var.private_subnet_ranges)
  vpc_id                  = var.vpc_id
  cidr_block              = var.private_subnet_ranges[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    "Name"                   = "eks-subnet-${count.index}",
    "karpenter.sh/discovery" = "${var.cluster_name}"
  }
}

resource "aws_security_group" "eks_cluster" {
  vpc_id = var.vpc_id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_ranges
  }

  tags = {
    "Name"                   = "eks-cluster",
    "karpenter.sh/discovery" = "${var.cluster_name}"
  }
}
