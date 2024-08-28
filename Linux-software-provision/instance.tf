resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_key_pair" "devopsmonks" {
#   key_name = "devopsmonks"
#   public_key = file(var.PATH_TO_PUBLIC_KEY)
# }

# resource "aws_instance" "example" {
#   ami = lookup(var.AMI, var.AWS_REGION)
#   instance_type = "t2.micro"
#    subnet_id     = aws_subnet.main.id
#   key_name = aws_key_pair.devopsmonks.key_name


#   provisioner "file" {
#     source = "script.sh"
#     destination = "C:/Windows/Temp/script.sh"
#   }
#   provisioner "remote-exec" {
#     inline = [
#       "chmod +x C:/Windows/Temp/script.sh",
#       "sudo ./script.sh"
#     ]
#   }
#   connection {
#     host = self.public_ip
#     user = var.INSTANCE_USERNAME
#     private_key = file(var.PATH_TO_PRIVATE_KEY)
#   }
#   tags = {
#   Name = "nginx"
#   }
# }
resource "aws_key_pair" "devopsmonks" {
  key_name   = "devopsmonks"
  public_key = file(var.PATH_TO_PUBLIC_KEY)
}

resource "aws_instance" "example" {
  ami             = lookup(var.AMI, var.AWS_REGION)
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.main.id
  key_name        = aws_key_pair.devopsmonks.key_name
  associate_public_ip_address = true

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
    connection {
      type        = "ssh"
      user        = var.INSTANCE_USERNAME
      private_key = file(var.PATH_TO_PRIVATE_KEY)
      host        = self.public_ip
    }
  }
provisioner "local-exec" {
  command = "sleep 180"
}
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "./tmp/script.sh"
    ]
    connection {
      type        = "ssh"
      user        = var.INSTANCE_USERNAME
      private_key = file(var.PATH_TO_PRIVATE_KEY)
      host        = self.public_ip
    }
  }

  tags = {
    Name = "nginx"
  }
}
