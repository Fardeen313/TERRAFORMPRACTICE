provider "aws" {
  region = "ap-south-1"
}
resource "aws_instance" "sample" {
  ami = "ami-0d682f26195e9ec0f"
  subnet_id = "subnet-0cda5ad3e644c6d65"
  key_name = "Ironman123"
  instance_type = "t2.micro"
  tags = {
    Name = "0123" 
  }
}
