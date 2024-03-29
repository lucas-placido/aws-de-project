resource "aws_instance" "ec2-instance" {
  ami           = "ami-0005e0cfe09cc9050"
  instance_type = "t2.micro"
  security_groups = [ var.security_group ]
  key_name = "deployer-key"
  iam_instance_profile = var.ec2_role
  # user_data = file("C:/Lucas/Python/aws/Terraform/ec2/user_data.sh")
  user_data = templatefile("C:/Lucas/Python/aws/Terraform/ec2/user_data.sh", {
    stream_name = var.kinesis_data_stream
  })
  tags = {
    Name = "tf-instance"
  }
  depends_on = [ aws_key_pair.deployer ]
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("C:/Lucas/Python/aws/Terraform/ec2/key-pair.pub")
}