resource "aws_vpc" "test-k8s-eks" {
  cidr_block       = "10.5.0.0/16"
  instance_tenancy = "default"

  tags {
    Name = "test-k8s-eks"
  }
}

resource "aws_subnet" "public-2a" {
  vpc_id                  = "${aws_vpc.test-k8s-eks.id}"
  cidr_block              = "10.5.0.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags {
    Name = "eks-public-2a"
  }
}

resource "aws_subnet" "public-2b" {
  vpc_id                  = "${aws_vpc.test-k8s-eks.id}"
  cidr_block              = "10.5.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true

  tags {
    Name = "eks-public-2b"
  }
}

resource "aws_subnet" "public-2c" {
  vpc_id                  = "${aws_vpc.test-k8s-eks.id}"
  cidr_block              = "10.5.4.0/24"
  availability_zone       = "us-west-2c"
  map_public_ip_on_launch = true

  tags {
    Name = "eks-public-2c"
  }
}

resource "aws_subnet" "private-2a" {
  vpc_id            = "${aws_vpc.test-k8s-eks.id}"
  cidr_block        = "10.5.1.0/24"
  availability_zone = "us-west-2a"

  tags {
    Name = "eks-private-2a"
  }
}

resource "aws_subnet" "private-2b" {
  vpc_id            = "${aws_vpc.test-k8s-eks.id}"
  cidr_block        = "10.5.3.0/24"
  availability_zone = "us-west-2b"

  tags {
    Name = "eks-private-2b"
  }
}

resource "aws_subnet" "private-2c" {
  vpc_id            = "${aws_vpc.test-k8s-eks.id}"
  cidr_block        = "10.5.5.0/24"
  availability_zone = "us-west-2c"

  tags {
    Name = "eks-private-2c"
  }
}

resource "aws_internet_gateway" "test-k8s-eks-igw" {
  vpc_id = "${aws_vpc.test-k8s-eks.id}"
}

resource "aws_route_table" "public-route" {
  vpc_id = "${aws_vpc.test-k8s-eks.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test-k8s-eks-igw.id}"
  }
}

resource "aws_route_table" "private-route" {
  vpc_id = "${aws_vpc.test-k8s-eks.id}"
}

resource "aws_route_table_association" "public-2a" {
  subnet_id      = "${aws_subnet.public-2a.id}"
  route_table_id = "${aws_route_table.public-route.id}"
}

resource "aws_route_table_association" "public-2b" {
  subnet_id      = "${aws_subnet.public-2b.id}"
  route_table_id = "${aws_route_table.public-route.id}"
}

resource "aws_route_table_association" "public-2c" {
  subnet_id      = "${aws_subnet.public-2c.id}"
  route_table_id = "${aws_route_table.public-route.id}"
}

resource "aws_route_table_association" "private-2a" {
  subnet_id      = "${aws_subnet.private-2a.id}"
  route_table_id = "${aws_route_table.private-route.id}"
}

resource "aws_route_table_association" "private-2b" {
  subnet_id      = "${aws_subnet.private-2b.id}"
  route_table_id = "${aws_route_table.private-route.id}"
}

resource "aws_route_table_association" "private-2c" {
  subnet_id      = "${aws_subnet.private-2c.id}"
  route_table_id = "${aws_route_table.private-route.id}"
}
