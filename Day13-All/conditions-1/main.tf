#================================================== Variables ========================

variable "key" {
  default = "t2.micro"
}
variable "type" {
  default = "Ironman123"
}
variable "name" {
  default = "condition"
}
variable "condition" {
  description = "if conditionis is true then instance will create"
  type = bool
  default = false
}


#================================================= Data Source =========================================

data "aws_subnet" "test" {
  filter {
    name = "tag:Name"
    values = [ "test" ]
  }
}
data "aws_ami" "ammu" {
     most_recent = true
     owners = ["amazon"]
     
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  filter {
    name = "name"
    values = [ "al2023-ami-2023.6.20250218.2-kernel-6.1-x86_64" ]
  }
}

#=========================================== Resource =========================================

resource "aws_instance" "name" {
  count = var.condition ? 1 : 0  
  ami = data.aws_ami.ammu.id
  instance_type = var.type
  subnet_id = data.aws_subnet.test.id
  key_name = var.key
  tags = {
    Name = var.name
  }
}