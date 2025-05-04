resource "aws_secretsmanager_secret" "rds_secret" {
  name        = "mysql-credentials"
  description = "RDS MySQL credentials stored securely"
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = "admin"
    password = "Password123!"  # Ideally, keep this out of code
  })
}

