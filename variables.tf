
variable "cidr_vpc" {
  description = "cidr range for VPC"
  type        = string
  default = "10.0.0.0/16"
}

variable "cidr_subnet" {
  description = "cidr range for public VPC Subnet"
  type        = string
  default = "10.0.1.0/24"
}

variable "k8s_name" {
  type        = string
  description = "cluster"
  default = "kubeadm-cluster"
}

variable "ami" {
  description = "amazon machine image"
  type        = map(string)
  default = {
    master = "ami-0866a3c8686eaeeba"
    worker-node = "ami-0866a3c8686eaeeba"
  }
}

variable "instance_type" {
  type = map(string)
  default = {
    master = "t2.medium"
    worker-node = "t2.micro"
  }
}

variable "key_name" {
  description = "keypair for the cluster"
  type        = string
  default = "k8s-cluster"
}

variable "node_count" {
  description = "# of worker nodes"
  type        = number
  default = 2
}

variable "github_workspace" {
  description = "The GitHub workspace directory"
  type        = string
  default = "{{ github.workspace }}"
}

variable "principal_arns" {
  description = "A list of principal arns allowed to assume the IAM role"
  default     = null
  type        = list(string)
}

variable "project" {
  description = "The project name to use for unique resource naming"
  default     = "terraform-series"
  type        = string
}