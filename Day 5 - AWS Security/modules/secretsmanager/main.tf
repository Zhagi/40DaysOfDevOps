resource "aws_secretsmanager_secret" "example_secret" {
  name = "zh-secrets"
}

resource "aws_secretsmanager_secret_version" "example_secret_version" {
  secret_id     = aws_secretsmanager_secret.example_secret.id
  secret_string = "MySecurePassword123"  
}
