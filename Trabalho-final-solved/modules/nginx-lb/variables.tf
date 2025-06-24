variable "instance_count" {
  description = "Number of EC2 instances to launch."
  type        = number
}

variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "aws_amis" {
  description = "Map of region to AMI."
  type        = map(string)
}

variable "key_name" {
  description = "SSH key name."
  type        = string
}

variable "path_to_key" {
  description = "Path to SSH private key."
  type        = string
}

variable "instance_username" {
  description = "EC2 instance username."
  type        = string
}

variable "project" {
  description = "Project name."
  type        = string
}

variable "workspace" {
  description = "Terraform workspace/environment name."
  type        = string
} 