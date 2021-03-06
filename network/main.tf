/** public network */
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
  // 名前解決有効化
  enable_dns_support = true
  // DNSホスト名自動割当
  enable_dns_hostnames = true
  tags = {
    Name = "example"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.example.id
}

/**
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.0.0/24"
  // public id address の自動割当
  map_public_ip_on_launch = true
  availability_zone       = "ap-northeast-1a"
}

// internet gateway
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}


// private network 
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.example.id
  cidr_block        = "10.0.64.0/24"
  availability_zone = "ap-northeast-1a"
  // public ipの割当不要
  map_public_ip_on_launch = false
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

// NAT Gateway
resource "aws_eip" "nat_gateway" {
  vpc = true
  depends_on = [
    aws_internet_gateway.example
  ]
}
resource "aws_nat_gateway" "example" {
  allocation_id = aws_eip.nat_gateway.id
  subnet_id     = aws_subnet.public.id
  depends_on = [
    aws_internet_gateway.example
  ]
}
resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = aws_nat_gateway.example.id
  destination_cidr_block = "0.0.0.0/0"
}
*/

// public network multi AZ
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_1"
  }
}
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_2"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

//  private multi AZ
resource "aws_subnet" "private_1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "private_subnet_1"
  }
}
resource "aws_subnet" "private_2" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "private_subnet_2"
  }
}

// NAT Gateway
resource "aws_eip" "nat_gateway_1" {
  vpc = true
  depends_on = [
    aws_internet_gateway.example
  ]
  tags = {
    Name = "nat_eip_1"
  }
}

resource "aws_eip" "nat_gateway_2" {
  vpc = true
  depends_on = [
    aws_internet_gateway.example
  ]
  tags = {
    Name = "nat_eip_2"
  }
}

resource "aws_nat_gateway" "nat_gateway_1" {
  allocation_id = aws_eip.nat_gateway_1.id
  subnet_id     = aws_subnet.private_1.id
  dependepends_on = [
    aws_internet_gateway.example
  ]
}

resource "aws_nat_gateway" "nat_gateway_2" {
  allocation_id = aws_eip.nat_gateway_2.id
  subnet_id     = aws_subnet.private_2.id
  dependepends_on = [
    aws_internet_gateway.example
  ]
}



