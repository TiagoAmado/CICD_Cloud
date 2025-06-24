variable "instance_count" {
  description = "Number of EC2 instances to launch."
  type        = number
  default     = 2
}

variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "us-east-1"
}

variable "aws_amis" {
  description = "Map of region to AMI."
  type        = map(string)
  default = {
    us-east-1 = "ami-087c17d1fe0178315"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}

variable "key_name" {
  description = "SSH key name."
  type        = string
  default     = "vockey"
}

variable "path_to_key" {
  description = "Path to SSH private key."
  type        = string
  default     = "/home/ubuntu/.ssh/vockey.pem"
}

variable "instance_username" {
  description = "EC2 instance username."
  type        = string
  default     = "ec2-user"
}

variable "project" {
  description = "Project name."
  type        = string
  default     = "fiap-lab"
}
