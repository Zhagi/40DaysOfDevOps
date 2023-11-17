resource "aws_iam_role" "config" {
  name = "awsconfig-example-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "config.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_policy" "config_custom_policy" {
  name        = "AWSConfigCustomPolicy"
  description = "Custom policy for AWS Config"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "config:Put*",
          "config:Get*",
          "config:List*",
          "config:Describe*",
          // Add any other necessary actions here
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "config" {
  role       = aws_iam_role.config.name
  policy_arn = aws_iam_policy.config_custom_policy.arn
}

resource "aws_s3_bucket" "config_bucket" {
  bucket = "zh-config-bucket"
}

resource "aws_s3_bucket_policy" "config_bucket_policy" {
  bucket = aws_s3_bucket.config_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetBucketAcl"
        ],
        Effect = "Allow",
        Resource = [
          "${aws_s3_bucket.config_bucket.arn}",
          "${aws_s3_bucket.config_bucket.arn}/*"
        ],
        Principal = {
          Service = "config.amazonaws.com",
        },
      }
    ]
  })
}

resource "aws_config_configuration_recorder" "example" {
  name     = "example-configuration-recorder"
  role_arn = aws_iam_role.config.arn

  recording_group {
    all_supported                 = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "example" {
  name           = "example-delivery-channel"
  s3_bucket_name = aws_s3_bucket.config_bucket.id

  depends_on = [aws_config_configuration_recorder.example]
}

resource "aws_config_config_rule" "example_rule" {
  name = "zh-config-rule"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_VERSIONING_ENABLED"
  }

  depends_on = [
    aws_config_delivery_channel.example
  ]
}

