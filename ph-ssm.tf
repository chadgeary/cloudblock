# pihole password as ssm parameter
resource "aws_ssm_parameter" "ph-ssm-param-pass" {
  name                    = "ph-pihole-web-password"
  type                    = "SecureString"
  key_id                  = aws_kms_key.ph-kmscmk-ssm.key_id
  value                   = var.ssm_web_password
}

# pihole playbook
resource "aws_ssm_association" "ph-ssm-assoc" {
  association_name        = "ph-pihole"
  name                    = "AWS-ApplyAnsiblePlaybooks"
  targets {
    key                   = "tag:ph"
    values                = ["True"]
  }
  output_location {
    s3_bucket_name          = aws_s3_bucket.ph-bucket.id
    s3_key_prefix           = "ssm"
  }
  parameters              = {
    Check                   = "False"
    ExtraVariables          = "SSM=True install_dir=${var.ssm_install_dir} dns_server_1=${var.ssm_dns_server_1} dns_server_2=${var.ssm_dns_server_2} aws_region=${var.aws_region}"
    InstallDependencies     = "True"
    PlaybookFile            = "cloud_pihole.yml"
    SourceInfo              = "{\"path\":\"https://s3.${var.aws_region}.amazonaws.com/${aws_s3_bucket.ph-bucket.id}/pihole/\"}"
    SourceType              = "S3"
    Verbose                 = "-v"
  }
  depends_on              = [aws_iam_role_policy_attachment.ph-iam-attach-ssm, aws_iam_role_policy_attachment.ph-iam-attach-s3,aws_s3_bucket_object.ph-files]
}
