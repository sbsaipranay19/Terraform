provider "aws" {
  region = "us-east-2" 
}

# --------------------------------------------------------------------------------------------------------------------
# CREATE Ec2 Instance
# --------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  tags = {
    Name = "ec2-instance"
  }
}

# --------------------------------------------------------------------------------------------------------------------
# CREATE Security Group
# --------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "instance" {
  name = "security-group"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_availability_zones" "all" {}
 
# --------------------------------------------------------------------------------------------------------------------
# CREATE Auto Scaling Group
# --------------------------------------------------------------------------------------------------------------------

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.id
  availability_zones   = data.aws_availability_zones.all.names
  min_size = 2
  max_size = 10
  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}