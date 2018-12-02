resource "aws_autoscaling_group" "eks-asg" {
  name                 = "EKS worker group"
  desired_capacity     = 3
  launch_configuration = "${aws_launch_configuration.eks-lc.id}"
  max_size             = 3
  min_size             = 3

  vpc_zone_identifier = [
    "${aws_subnet.public-2a.id}",
    "${aws_subnet.public-2b.id}",
    "${aws_subnet.public-2c.id}",
  ]

  tag {
    key                 = "Name"
    value               = "eks-worker"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${local.cluster_name}"
    value               = "owned"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
