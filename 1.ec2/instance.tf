resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}
resource "aws_instance" "example" {
  ami           = lookup(var.AMI, var.AWS_REGION, "ami-not-found")
  instance_type = "t2.micro"
   subnet_id     = aws_subnet.main.id

  tags = {
    Name = "example-instance"
  }
}
