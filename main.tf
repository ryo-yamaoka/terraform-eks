locals {
  region      = "us-west-2"
}

variable "access_key_id" {}
variable "secret_access_key" {}

provider "aws" {
  access_key = "${var.access_key_id}"
  secret_key = "${var.secret_access_key}"
  region     = "${local.region}"
}

output "kubectl config" {
  value = "${local.kubeconfig}"
}

output "EKS ConfigMap" {
  value = "${local.eks_configmap}"
}
