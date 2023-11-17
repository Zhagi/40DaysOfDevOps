data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket = "zh-cloudtrail-logs"
  // Additional configurations, if any...
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "s3:GetBucketAcl",
        Resource = "arn:aws:s3:::zh-cloudtrail-logs",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
      },
      {
        Effect = "Allow",
        Action = "s3:PutObject",
        Resource = "arn:aws:s3:::zh-cloudtrail-logs/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}
