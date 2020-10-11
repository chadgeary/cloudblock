# pihole password as ssm parameter
resource "aws_ssm_parameter" "ph-ssm-param-pass" {
  name                    = "${var.ec2_name_prefix}-pihole-web-password"
  type                    = "SecureString"
  key_id                  = aws_kms_key.ph-kmscmk-ssm.key_id
  value                   = var.pihole_password
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
    ExtraVariables          = "SSM=True aws_region=${var.aws_region} name_prefix=${var.ec2_name_prefix} s3_bucket=${aws_s3_bucket.ph-bucket.id} kms_key_id=${aws_kms_key.ph-kmscmk-s3.key_id} docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_doh=${var.docker_doh} docker_pihole=${var.docker_pihole} docker_wireguard=${var.docker_wireguard} wireguard_network=${var.wireguard_network} doh_provider=${var.doh_provider}"
    InstallDependencies     = "False"
    PlaybookFile            = "cloud_pihole.yml"
    SourceInfo              = "{\"path\":\"https://s3.${var.aws_region}.amazonaws.com/${aws_s3_bucket.ph-bucket.id}/pihole/\"}"
    SourceType              = "S3"
    Verbose                 = "-v"
  }
  depends_on              = [aws_iam_role_policy_attachment.ph-iam-attach-ssm, aws_iam_role_policy_attachment.ph-iam-attach-s3,aws_s3_bucket_object.ph-files]
}
