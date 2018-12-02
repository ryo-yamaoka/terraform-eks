resource "aws_security_group" "cluster-master" {
  name        = "cluster-master"
  description = "test k8s EKS cluster nodes security group"

  tags {
    Name = "test-k8s-eks-cluster-master-sg"
  }

  vpc_id = "${aws_vpc.test-k8s-eks.id}"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "cluster-nodes" {
  name        = "cluster-nodes"
  description = "test k8s EKS cluster nodes security group"

  tags {
    Name = "test-k8s-eks-cluster-nodes-sg"
  }

  vpc_id = "${aws_vpc.test-k8s-eks.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow internet facing LB, internal LB, and control plane"
    from_port   = 1025
    to_port     = 65535
    protocol    = "tcp"

    security_groups = [
      "${aws_security_group.inet-lb.id}",
      "${aws_security_group.internal-lb.id}",
      "${aws_security_group.cluster-master.id}",
    ]
  }

  ingress {
    description = "Allow internet facing LB, internal LB, and control plane"
    from_port   = 1025
    to_port     = 65535
    protocol    = "udp"

    security_groups = [
      "${aws_security_group.inet-lb.id}",
      "${aws_security_group.internal-lb.id}",
      "${aws_security_group.cluster-master.id}",
    ]
  }

  ingress {
    description = "Allow inter pods communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "inet-lb" {
  name        = "inet-lb"
  description = "test k8s EKS internet facing LB security group"

  tags {
    Name = "test-k8s-eks-inet-lb-sg"
  }

  vpc_id = "${aws_vpc.test-k8s-eks.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "internal-lb" {
  name        = "internal-lb"
  description = "test k8s EKS internal LB security group"

  tags {
    Name = "test-k8s-eks-internal-lb-sg"
  }

  vpc_id = "${aws_vpc.test-k8s-eks.id}"

  ingress {
    description = "temporary"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
