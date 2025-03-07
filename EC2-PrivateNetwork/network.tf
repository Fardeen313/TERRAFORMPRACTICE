#==================================================( Provider Block )=================================================

provider "aws" {
  region = "ap-south-1"
}
#==================================================( Public Server )=====================================================

# resource "aws_instance" "public_server" {
#     ami = data.aws_ami.test.id
#     instance_type = "t2.micro"
#     key_name = "Ironman123"
#     subnet_id = "subnet-0cda5ad3e644c6d65"
#     associate_public_ip_address = true
#     tags = {
#       Name = "PublicServer"
#     }
#     provisioner "file" {
#       source = "Ironman123.pem"
#       destination = "/home/ec2-user/Ironman123.pem"

#     }
# }
#===================================( Custom Subnet & RT And NatGateway For Private Server )=============================

resource "aws_eip" "test" {
   domain = "vpc"
   tags = {
     Name = "eip"
   }
}
resource "aws_nat_gateway" "test" {  
  subnet_id = "subnet-0cda5ad3e644c6d65"  # public subnet 
  allocation_id = aws_eip.test.id
  tags = {
    Name = "custon nat gateway"
  }

}
resource "aws_route_table" "test" {
    vpc_id = "vpc-0b481dd1f52b87295"
    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.test.id
    }
    tags = {
      Name = "NatRT"
    }
}
resource "aws_route_table_association" "test" {
  route_table_id = aws_route_table.test.id
  subnet_id = aws_subnet.test.id
}

# data "aws_ami" "test" {
#   owners = ["amazon"]
#   most_recent = true
#   filter {
#     name = "name"
#     values = [ "amzn2-ami-kernel-5.10-hvm-2.0.20250201.0-x86_64-gp2" ]
#   }
#   filter {
#     name = "root-device-type"
#     values = [ "ebs" ]
#   }
#   filter {
#     name = "virtualization-type"
#     values = [ "hvm" ]
#   }
#   filter {
#     name = "architecture"
#     values = [ "x86_64" ]
#   }
# }

resource "aws_subnet" "test" {
  vpc_id = "vpc-0b481dd1f52b87295"
  cidr_block = "172.31.129.128/25"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "custom_subnet"
  }
}

# resource "aws_instance" "private_server" {
#   subnet_id = aws_subnet.test.id
#   instance_type = "t2.micro"
#   key_name = "Ironman123"
#   ami = data.aws_ami.test.id
#   associate_public_ip_address = false
#   tags = {
#     Name = "custom-server"
#   }

#   depends_on = [aws_instance.public_server]

#   provisioner "remote-exec" {
#     connection {
#       type        = "ssh"
#       user        = "ec2-user"
#       private_key = file("Ironman123.pem")
#       host        = self.private_ip
#       bastion_host = aws_instance.public_server.public_ip
#       bastion_user = "ec2-user"
#     }
#     inline = [
#       "chmod 400 Ironman123.pem",
#       "echo Connected to private server via public server"
#     ]
#   }
# }

#----------------------------------------------------------------------------------------------------------------

# provider "aws" {
  
# }
# resource "aws_instance" "test" {
#     ami = data.aws_ami.test.id
#     instance_type = "t2.micro"
#     key_name = "Ironman123"
#     subnet_id = "subnet-0cda5ad3e644c6d65"
#     associate_public_ip_address = true
#     tags = {
#       Name = "*PublicServer*"
#     }
#     connection {
#       host = self.public_ip
#       type = "ssh"
#       private_key = "Ironman123.pem"
#       user = "ec2-user"
#     }
  
# }
# data "aws_ami" "test" {
#   owners = ["amazon"]
#   most_recent = true
#   filter {
#     name = "name"
#     values = [ "amzn2-ami-kernel-5.10-hvm-2.0.20250201.0-x86_64-gp2" ]
#   }
#   filter {
#     name = "root-device-type"
#     values = [ "ebs" ]
#   }
#   filter {
#     name = "virtualization-type"
#     values = [ "hvm" ]
#   }
#   filter {
#     name = "architecture"
#     values = [ "x86_64" ]
#   }
# }
# resource "aws_subnet" "test" {
#   vpc_id = "vpc-0b481dd1f52b87295"
#   cidr_block = "172.31.129.128/25"
#   availability_zone = "ap-south-1a"
#   tags = {
#     Name = "custom_subnet"
#   }
# }
# resource "aws_eip" "test" {
#    domain = "vpc"
#    tags = {
#      Name = "eip"
#    }
# }
# resource "aws_nat_gateway" "test" {  
#   subnet_id = aws_subnet.test.id
#   allocation_id = aws_eip.test.id
#   tags = {
#     Name = "custon nat gateway"
#   }

# }
# resource "aws_route_table" "test" {
#     vpc_id = "vpc-0b481dd1f52b87295"
#     route {
#         cidr_block = "0.0.0.0/0"
#         nat_gateway_id = aws_nat_gateway.test.id
#     }
#     tags = {
#       Name = "NatRT"
#     }
# }
# resource "aws_route_table_association" "test" {
#   route_table_id = aws_route_table.test.id
#   subnet_id = aws_subnet.test.id
# }
# resource "aws_instance" "test" {
#   subnet_id = aws_subnet.test.id
#   instance_type = "t2.micro"
#   key_name = "Ironman123"
#   ami = data.aws_ami.test.id
#   associate_public_ip_address = false
#   tags = {
#     Name = "custom-server"
#   }
# }









# # Install Apache (if not installed)
# sudo yum install -y httpd

# # Edit Apache configuration file
# sudo nano /etc/httpd/conf/httpd.conf

# # Change the Listen directive to use port 8080 (inside httpd.conf)
# Listen 0.0.0.0:8080
# # Optional: Comment out IPv6 if not needed
# # Listen [::]:8080

# # Restart Apache to apply changes
# sudo systemctl restart httpd

# # Verify if Apache is running on the correct port
# sudo netstat -tulnp | grep 8080

# # Test Apache locally
# curl -I http://127.0.0.1:8080
