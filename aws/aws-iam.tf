# SSM Managed Policy
data "aws_iam_policy" "ph-instance-policy-ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Policy SSM Parameter
resource "aws_iam_policy" "ph-instance-policy-ssmparameter" {
  name        = "ph-instance-policy-ssmparameter"
  path        = "/"
  description = "Provides ph instances access to ssm parameter(s)"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "GetSSMParameter",
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters"
      ],
      "Resource": ["${aws_ssm_parameter.ph-ssm-param-pass.arn}"]
    },
    {
      "Sid": "SSMCMK",
      "Effect": "Allow",
      "Action": "kms:Decrypt",
      "Resource": ["${aws_kms_key.ph-kmscmk-ssm.arn}"]
    }
  ]
}
EOF
}

# Instance Policy S3
resource "aws_iam_policy" "ph-instance-policy-s3" {
  name        = "ph-instance-policy-s3"
  path        = "/"
  description = "Provides ph instances access to s3 objects/bucket"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListObjectsinBucket",
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket"
      ],
      "Resource": ["${aws_s3_bucket.ph-bucket.arn}"]
    },
    {
      "Sid": "GetObjectsinBucketPrefix",
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion"
      ],
      "Resource": ["${aws_s3_bucket.ph-bucket.arn}/playbooks/*","${aws_s3_bucket.ph-bucket.arn}/pihole/*","${aws_s3_bucket.ph-bucket.arn}/wireguard/*"]
    },
    {
      "Sid": "PutObjectsinBucketPrefix",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:PutObjectAcl"
      ],
      "Resource": ["${aws_s3_bucket.ph-bucket.arn}/ssm/*","${aws_s3_bucket.ph-bucket.arn}/pihole/*","${aws_s3_bucket.ph-bucket.arn}/wireguard/*"]
    },
    {
      "Sid": "S3CMK",
      "Effect": "Allow",
      "Action": [
        "kms:Encrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ],
      "Resource": ["${aws_kms_key.ph-kmscmk-s3.arn}"]
    }
  ]
}
EOF
}

# Instance Role
resource "aws_iam_role" "ph-instance-iam-role" {
  name               = "ph-instance-profile-${random_string.ph-random.result}-role"
  path               = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "sts:AssumeRole",
          "Principal": {
             "Service": "ec2.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
      }
  ]
}
EOF
}

# Instance Role Attachments
resource "aws_iam_role_policy_attachment" "ph-iam-attach-ssm" {
  role       = aws_iam_role.ph-instance-iam-role.name
  policy_arn = data.aws_iam_policy.ph-instance-policy-ssm.arn
}

resource "aws_iam_role_policy_attachment" "ph-iam-attach-ssmparameter" {
  role       = aws_iam_role.ph-instance-iam-role.name
  policy_arn = aws_iam_policy.ph-instance-policy-ssmparameter.arn
}

resource "aws_iam_role_policy_attachment" "ph-iam-attach-s3" {
  role       = aws_iam_role.ph-instance-iam-role.name
  policy_arn = aws_iam_policy.ph-instance-policy-s3.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "ph-instance-profile" {
  name = "ph-instance-profile-${random_string.ph-random.result}"
  role = aws_iam_role.ph-instance-iam-role.name
}
