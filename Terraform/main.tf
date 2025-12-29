 data "aws_subnet" "project_subnet" {
    id = "subnet-0e4df40e74e75d6e5"
  }
resource "aws_security_group" "project_sg" {
  name        = "project_sg"
  description = "open port 22,443,80,8080,9000 for project"

 

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "TLS FROM VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project_sg"
  }
}

resource "aws_instance" "project_instance" {
  ami           = "ami-0ecb62995f68bb549" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.large"

  key_name               = "first"
  subnet_id              = data.aws_subnet.project_subnet.id
  vpc_security_group_ids = [aws_security_group.project_sg.id]
  user_data              = templatefile("./resource.sh", {})

  tags = {
    Name = "project_instance"
  }

  root_block_device {
    volume_size = 30
  }
}