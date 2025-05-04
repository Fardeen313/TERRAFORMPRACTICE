provider "aws" {
  region = "us-east-1"
}
# Create the RDS instance
resource "aws_db_instance" "mysql_rds" {
  identifier             = "my-mysql-db"
  engine                 = "mysql"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "Password123!"
  db_name                = "dev"
  allocated_storage      = 20
  skip_final_snapshot    = true
  publicly_accessible    = false
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.allow_all.id]
}

data "aws_iam_instance_profile" "existing_profile" {
  name = "EC2_ADMIN" # Replace with your instance profile name
}

resource "aws_instance" "ec2_host" {
  ami                         = "ami-0e449927258d45bc4"
  key_name                    = "public"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  iam_instance_profile        = data.aws_iam_instance_profile.existing_profile.name
  subnet_id                   = aws_subnet.public_subnet_1.id
  security_groups             = [aws_security_group.allow_all.id]
  tags = {
    Name = "rds-connect-server"
  }
}
# Use null_resource to execute the SQL script from your remote machine
resource "null_resource" "remote_sql_exec" {
  depends_on = [aws_db_instance.mysql_rds, aws_instance.ec2_host]

  connection {
    type        = "ssh"
    host        = aws_instance.ec2_host.public_ip
    user        = "ec2-user"           # or ubuntu, based on AMI
    private_key = file("~/public.pem") # your private key file
  }

  provisioner "file" {
    source      = "init.sql"  # Make sure this is correct
    destination = "/tmp/init.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y mariadb105-server aws-cli jq",
      "sudo systemctl enable mariadb || sudo systemctl enable mariadb105 || true",
      "sudo systemctl start mariadb || sudo systemctl start mariadb105",
      <<-EOC
        SECRET=$(aws secretsmanager get-secret-value --secret-id mysql-credentials --query SecretString --output text) && \
        USERNAME=$(echo $SECRET | jq -r .username) && \
        PASSWORD=$(echo $SECRET | jq -r .password) && \
        mysql -h \"${aws_db_instance.mysql_rds.address}\" -u $USERNAME -p$PASSWORD dev < /tmp/init.sql
      EOC
    ]
  }

  triggers = {
    always_run = timestamp()
  }
}

