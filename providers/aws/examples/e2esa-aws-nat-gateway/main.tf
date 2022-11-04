
# terraform apply -var-file="app.tfvars" -var="createdBy=e2esa"

locals {
  name = "${var.project}-${var.prefix}"
  tags = {
    Project     = var.project
    CreatedBy   = var.createdBy
    CreatedOn   = timestamp()
    Environment = terraform.workspace
  }
}

resource "aws_eip" "this" {
  vpc      = true
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = var.nat_public_subnet_id 
  connectivity_type = "public" #"private"

tags = merge({ "ResourceName" = "nat-gateway" }, local.tags)

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  #depends_on = [aws_internet_gateway.example]
}


resource "aws_route_table" "nat_gateway_rt" {
  vpc_id = var.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this.id
  }
}

resource "aws_route_table_association" "nat_gateway_assoc" {
  subnet_id = var.nat_public_subnet_id
  route_table_id = aws_route_table.nat_gateway_rt.id
}