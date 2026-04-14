resource "aws_vpc" "safle-app-vpc"{
  cidr_block= "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}      

resource "aws_subnet" "public-subnet-1" {
  vpc_id     = aws_vpc.safle-app-vpc.id
  availability_zone= "ap-south-1a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-1"
  }
  
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id     = aws_vpc.safle-app-vpc.id
  availability_zone= "ap-south-1b"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-2"
  }
  
}

resource "aws_subnet" "private-subnet-1" {
  vpc_id     = aws_vpc.safle-app-vpc.id
  availability_zone = "ap-south-1a"
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "private-subnet-1"
  }
}

resource "aws_subnet" "private-subnet-2" {
  vpc_id     = aws_vpc.safle-app-vpc.id
  availability_zone = "ap-south-1b"
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "private-subnet-2"
  }
}

resource "aws_internet_gateway" "safle-igw" {
  vpc_id = aws_vpc.safle-app-vpc.id
  tags = {
    Name = "safle-igw"
  }
}


resource "aws_eip" "safle-eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "safle-ngw"{
    allocation_id= aws_eip.safle-eip.id
    subnet_id= aws_subnet.public-subnet-1.id
    depends_on = [aws_internet_gateway.safle-igw]

    tags={
        Name= "safle-ngw"
    }
}


resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.safle-app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.safle-igw.id
  }
  tags = {
    Name = "public_route"
  }
}


resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.safle-app-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.safle-ngw.id
  }
  tags = {
    Name = "private_route"
  }
}



resource "aws_route_table_association" "public-association" {
  subnet_id      = aws_subnet.public-subnet-1.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "public2-association" {
  subnet_id      = aws_subnet.public-subnet-2.id
  route_table_id = aws_route_table.public_route.id
}

resource "aws_route_table_association" "private-association" {
  subnet_id      = aws_subnet.private-subnet-1.id
  route_table_id = aws_route_table.private_route.id
}

resource "aws_route_table_association" "private2-association" {
  subnet_id      = aws_subnet.private-subnet-2.id
  route_table_id = aws_route_table.private_route.id
}
