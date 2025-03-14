/*========================================== Provider ==================================================*/

provider "aws" {

}
/*========================================== Locals =====================================================*/
locals {
  typeinst = "t2.medium"
  tag      = "(|*Jenkins*|)"
}

/*====================================== KeyPair & Instance ==============================================*/

resource "aws_key_pair" "pubkey" {
  key_name = "JenkinServerKey"
  public_key = file("~/.ssh/id_rsa.pub")
}

  resource "aws_instance" "jenkins" {
  ami           = data.aws_ami.fardeen.id
  subnet_id     = data.aws_subnet.mumb.id
  key_name      = aws_key_pair.pubkey.key_name
  instance_type = local.typeinst
  associate_public_ip_address = true
  user_data     = file("jenkin.sh")
  tags = {
    Name = local.tag
  }
  provisioner "remote-exec" {
   inline = [
    "echo 'Granting full permissions...'",
    "sudo chmod -R 777 /var/lib/jenkins/",

    "echo 'Starting Jenkins service...'",
    "sudo systemctl start jenkins",
    "sudo systemctl enable jenkins",

    "echo 'Waiting for Jenkins to initialize (Max 5 minutes)...'",
    "timeout 300 sh -c 'while [ ! -f /var/lib/jenkins/secrets/initialAdminPassword ]; do sleep 5; done'",

    "echo 'Jenkins Initial Admin Password:'",
    "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
     ]
  }
  connection {
    type = "ssh"
    user = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host = self.public_ip
  }
  depends_on = [ aws_key_pair.pubkey ]
}


/*========================================== Data-Source ===================================================*/

data "aws_ami" "fardeen" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.6.20250218.2-kernel-6.1-x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]

  }
}


data "aws_subnet" "mumb" {
  filter {
    name   = "tag:Name"
    values = ["test"]
  }
}

/*============================================= Output Block ===================================================*/

output "aws_ami" {
  value = data.aws_ami.fardeen.image_id
}
output "awssubnt" {
  value = data.aws_subnet.mumb.id
}
output "awssubnttag" {
  value = data.aws_subnet.mumb.tags
}
output "awsinst" {
  value = aws_instance.jenkins.id
}
output "publi_ip_of_the_instance" {
  value = aws_instance.jenkins.public_ip
}