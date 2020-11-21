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
  OUTPUT
}
