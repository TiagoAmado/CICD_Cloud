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

# VPC and subnet data sources

data "aws_vpc" "vpc" {
  tags = {
    Name = var.project
  }
}

data "aws_subnets" "all" {
  filter {
    name   = "tag:Tier"
    values = ["Public"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.all.ids)
  id       = each.value
}

resource "random_shuffle" "random_subnet" {
  input        = [for s in data.aws_subnet.public : s.id]
  result_count = 1
}

resource "aws_security_group" "allow_ssh" {
  vpc_id = data.aws_vpc.vpc.id
  name   = "allow-ssh-${var.workspace}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh-${var.workspace}"
  }
}

resource "aws_elb" "web" {
  name = "elb-${var.workspace}"

  subnets         = data.aws_subnets.all.ids
  security_groups = [aws_security_group.allow_ssh.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 6
  }

  instances = aws_instance.web.*.id
}

resource "aws_instance" "web" {
  instance_type = "t3.micro"
  ami           = lookup(var.aws_amis, var.aws_region)

  count = var.instance_count

  subnet_id              = random_shuffle.random_subnet.result[0]
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name               = var.key_name

  provisioner "file" {
    source      = "${path.module}/script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]
  }

  connection {
    user        = var.instance_username
    private_key = file(var.path_to_key)
    host        = self.public_dns
  }

  tags = {
    Name = "nginx-${var.workspace}-${format("%03d", count.index + 1)}"
  }
} 