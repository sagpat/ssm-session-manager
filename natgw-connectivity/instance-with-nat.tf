data "aws_ami" "ubuntu_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  owners = ["099720109477"]
}


resource "aws_instance" "ssm_nat_instance" {
  ami                    = data.aws_ami.ubuntu_ami.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ssm_instance_profile.name
  monitoring             = true
  root_block_device {
    delete_on_termination = true
    volume_size           = 10
    volume_type           = "gp3"
  }

  tags = merge(local.tags,
    {
      Name = "ssm-nat-instance"
    }
  )
}

