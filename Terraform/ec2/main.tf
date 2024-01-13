resource "aws_instance" "ec2-instance" {
  ami           = "ami-0005e0cfe09cc9050"
  instance_type = "t2.micro"
  security_groups = [ var.security_group[0] ]
  key_name = "key-pair"
  user_data = file("C:/Lucas/Python/aws/Terraform/ec2/user_data.sh")
  tags = {
    Name = "tf-instance"
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("key-pair.pub")
}