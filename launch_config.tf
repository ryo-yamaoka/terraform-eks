locals {
  ami_id        = "ami-0a54c984b9f908c81" # us-west-2, EKS Kubernetes Worker AMI with AmazonLinux2
  instance_type = "t2.medium"
  key_name      = "your-eks-worker-key"
  volume_type   = "gp2"
  volume_size   = 50

  userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint "${aws_eks_cluster.test-eks-master.endpoint}" --b64-cluster-ca "${aws_eks_cluster.test-eks-master.certificate_authority.0.data}" "${aws_eks_cluster.test-eks-master.name}"
USERDATA
}

resource "aws_launch_configuration" "eks-lc" {
  associate_public_ip_address = true
  iam_instance_profile        = "${aws_iam_instance_profile.eks-node-role-profile.id}"
  image_id                    = "${local.ami_id}"
  instance_type               = "${local.instance_type}"
  name_prefix                 = "eks-node"
  key_name                    = "${local.key_name}"
  enable_monitoring           = false
  spot_price                  = 0.0464

  root_block_device {
    volume_type = "${local.volume_type}"
    volume_size = "${local.volume_size}"
  }

  security_groups  = ["${aws_security_group.cluster-nodes.id}"]
  user_data_base64 = "${base64encode(local.userdata)}"

  lifecycle {
    create_before_destroy = true
  }
}
