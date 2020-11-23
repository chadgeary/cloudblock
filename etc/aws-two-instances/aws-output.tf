output "cloudblock-output" {
  value = <<OUTPUT
  
  #############  
  ## OUTPUTS ##
  #############
  
  ## SSH (VPN) ##
  ssh ubuntu@${aws_eip.ph-eip-1.public_ip}
  (ssh ubuntu@${var.docker_gw})
  
  ## WebUI (VPN) ##
  https://${aws_eip.ph-eip-1.public_ip}/admin/
  (https://${var.docker_webproxy}/admin/)
  
  ## Wireguard Configurations ##
  https://s3.console.aws.amazon.com/s3/buckets/${aws_s3_bucket.ph-bucket.id}/wireguard/?region=${var.aws_region}&tab=overview

  ## Update / Ansible Rerun ##
  mv aws.tfvars pvars.tfvars
  git pull
  diff pvars.tfvars aws.tfvars
  mv pvars.tfvars aws.tfvars
  terraform apply -var-file="aws.tfvars"
  ~/.local/bin/aws ssm start-associations-once --region ${var.aws_region} --association-ids ${aws_ssm_association.ph-ssm-assoc.association_id}
  OUTPUT
}
