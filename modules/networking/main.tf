data "aws_availability_zones" "available" {}

resource "aws_subnet" "eks_subnets" {
  count                   = length(var.subnet_ranges)
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_ranges[count.index]
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
    cidr_blocks = var.subnet_ranges
  }

  tags = {
    "Name"                   = "eks-cluster",
    "karpenter.sh/discovery" = "${var.cluster_name}"
  }
}
