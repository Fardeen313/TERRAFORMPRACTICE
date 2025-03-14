provider "aws" {
  
}
data "aws_ami" "myami" {
  owners = [ "amazon" ]
  most_recent = true
  filter {
    name = "name"
    values = [ "al2023-ami-2023.6.20250303.0-kernel-6.1-x86_64" ]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
  filter {
    name = "root-device-type"
    values = [ "ebs" ]
  }
  filter {
    name = "architecture"
    values = [ "x86_64" ]
  }

}
data "aws_subnet" "mysubnet" {
  filter {
    name = "tag:Name"
    values = [ "test" ]
  }
}
data "aws_security_group" "defaultsg" {
  filter {
    name = "tag:Name"
    values = [ "default" ]
  }
}


output "subnet-id-ami-id" {
  value = {
    ami-id = data.aws_ami.myami.id
    subnet_id = data.aws_subnet.mysubnet.id
    security_group = data.aws_security_group.defaultsg.id
  }
}
resource "aws_instance" "sonarqube" {
  instance_type = "t2.medium"
  ami = data.aws_ami.myami.id
  subnet_id = data.aws_subnet.mysubnet.id
  security_groups = [ data.aws_security_group.defaultsg.id ]
  key_name = "Ironman123"
  associate_public_ip_address = true
  user_data = file(".sh")
  
}