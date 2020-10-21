# s3 bucket
resource "aws_s3_bucket" "ph-bucket" {
  bucket                  = var.bucket_name
  acl                     = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.ph-kmscmk-s3.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
  force_destroy           = true
  policy                  = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "KMS Manager",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${data.aws_iam_user.ph-kmsmanager.arn}"]
      },
      "Action": [
        "s3:*"
      ],
      "Resource": [
        "arn:aws:s3:::${var.bucket_name}",
        "arn:aws:s3:::${var.bucket_name}/*"
      ]
    },
    {
      "Sid": "Instance List",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${aws_iam_role.ph-instance-iam-role.arn}"]
      },
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": ["arn:aws:s3:::${var.bucket_name}"]
    },
    {
      "Sid": "Instance Get",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${aws_iam_role.ph-instance-iam-role.arn}"]
      },
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ],
      "Resource": ["arn:aws:s3:::${var.bucket_name}/*"]
    },
    {
      "Sid": "Instance Put",
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${aws_iam_role.ph-instance-iam-role.arn}"]
      },
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": [
        "arn:aws:s3:::${var.bucket_name}/ssm/*",
        "arn:aws:s3:::${var.bucket_name}/wireguard/*"
      ]
    }
  ]
}
POLICY
}

# s3 block all public access to bucket
resource "aws_s3_bucket_public_access_block" "ph-bucket-pubaccessblock" {
  bucket                  = aws_s3_bucket.ph-bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# s3 objects (playbook)
resource "aws_s3_bucket_object" "ph-files" {
  for_each                = fileset("playbook/", "*")
  bucket                  = aws_s3_bucket.ph-bucket.id
  key                     = "playbook/${each.value}"
  content_base64          = base64encode(file("${path.module}/playbook/${each.value}"))
  kms_key_id              = aws_kms_key.ph-kmscmk-s3.arn
}
