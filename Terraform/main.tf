 data "aws_subnet" "project_subnet" {
    id = "	
subnet-07560ddbc15e722af"
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
  ami           = "ami-0f5fcdfbd140e4ab7" 

  key_name               = "sample"
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