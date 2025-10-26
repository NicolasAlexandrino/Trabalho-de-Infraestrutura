resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  bucket_full_name = replace("infra.prova-${random_id.suffix.hex}", ".", "-")
}

resource "aws_s3_bucket" "app_bucket" {
  provider = aws.localstack
  bucket   = local.bucket_full_name
}




# ACL do bucket
resource "aws_s3_bucket_acl" "app_bucket_acl" {
  provider = aws.localstack
  bucket   = aws_s3_bucket.app_bucket.id
  acl      = "private"
}

# Usuários IAM
resource "aws_iam_user" "lab_user" {
  provider = aws.localstack
  name     = "infra_prova_user"
}

resource "aws_iam_user" "lab_user_2" {
  provider = aws.localstack
  name     = "infra_prova_user_2"
}

# Política IAM
resource "aws_iam_user_policy" "lab_user_policy" {
  provider = aws.localstack
  name     = "lab_user_policy"
  user     = aws_iam_user.lab_user.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid      = "ListBucket"
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = aws_s3_bucket.app_bucket.arn
      },
      {
        Sid      = "ObjectRW"
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:GetObject"]
        Resource = "${aws_s3_bucket.app_bucket.arn}/*"
      }
    ]
  })
}
