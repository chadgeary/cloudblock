# s3 bucket
resource "aws_s3_bucket" "ph-bucket" {
  bucket        = "${var.name_prefix}-${random_string.ph-random.result}"
  force_destroy = true
}

# acl
resource "aws_s3_bucket_acl" "ph-bucket" {
  bucket = aws_s3_bucket.ph-bucket.id
  acl    = "private"
}

# versioning
resource "aws_s3_bucket_versioning" "ph-bucket" {
  bucket = aws_s3_bucket.ph-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "ph-bucket" {
  bucket = aws_s3_bucket.ph-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.ph-kmscmk-s3.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# access policy
resource "aws_s3_bucket_policy" "ph-bucket-policy" {
  bucket = aws_s3_bucket.ph-bucket.id
  policy = data.aws_iam_policy_document.ph-bucket-policy.json
}

# s3 objects (playbook)
resource "aws_s3_object" "ph-files" {
  for_each       = fileset("../playbooks/", "*")
  bucket         = aws_s3_bucket.ph-bucket.id
  key            = "playbook/${each.value}"
  content_base64 = base64encode(file("${path.module}/../playbooks/${each.value}"))
  kms_key_id     = aws_kms_key.ph-kmscmk-s3.arn
}

# policy data
data "aws_iam_policy_document" "ph-bucket-policy" {
  statement {
    sid       = "KMSManager"
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = ["arn:aws:s3:::${var.name_prefix}-${random_string.ph-random.result}", "arn:aws:s3:::${var.name_prefix}-${random_string.ph-random.result}/*"]
    principals {
      type        = "AWS"
      identifiers = ["${data.aws_iam_user.ph-kmsmanager.arn}"]
    }
  }

  statement {
    sid       = "InstanceListGet"
    effect    = "Allow"
    actions   = ["s3:ListBucket", "s3:GetObject", "s3:GetObjectVersion", "s3:GetObjectTagging"]
    resources = ["arn:aws:s3:::${var.name_prefix}-${random_string.ph-random.result}", "arn:aws:s3:::${var.name_prefix}-${random_string.ph-random.result}/*"]
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_role.ph-instance-iam-role.arn}"]
    }
  }

  statement {
    sid       = "InstancePut"
    effect    = "Allow"
    actions   = ["s3:PutObject", "s3:PutObjectAcl", "s3:PutObjectTagging"]
    resources = ["arn:aws:s3:::${var.name_prefix}-${random_string.ph-random.result}/ssm/*", "arn:aws:s3:::${var.name_prefix}-${random_string.ph-random.result}/wireguard/*"]
    principals {
      type        = "AWS"
      identifiers = ["${aws_iam_role.ph-instance-iam-role.arn}"]
    }
  }
}
