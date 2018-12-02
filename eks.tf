locals {
  cluster_name = "test-eks-master"

  kubeconfig = <<KUBECONFIG
apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.test-eks-master.endpoint}
    certificate-authority-data: ${aws_eks_cluster.test-eks-master.certificate_authority.0.data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${local.cluster_name}"
KUBECONFIG

  eks_configmap = <<CONFIGMAPAWSAUTH
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.eks-node-role.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
CONFIGMAPAWSAUTH
}

resource "aws_eks_cluster" "test-eks-master" {
  name     = "${local.cluster_name}"
  role_arn = "${aws_iam_role.eks-master-role.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.cluster-master.id}"]

    subnet_ids = [
      "${aws_subnet.public-2a.id}",
      "${aws_subnet.public-2b.id}",
      "${aws_subnet.public-2c.id}",
    ]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks-cluster-policy",
    "aws_iam_role_policy_attachment.eks-service-policy",
  ]
}
