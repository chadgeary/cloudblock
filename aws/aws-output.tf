output "ph-pihole-ssh" {
  value                   = "SSH via: ubuntu@${aws_eip.ph-eip-1.public_ip}"
}

output "ph-pihole-web" {
  value                   = "pihole WebUI will be available @ https://${aws_eip.ph-eip-1.public_ip}/admin/"
}

output "ph-wireguard-s3" {
  value                   = "Wireguard configuration will be available @ https://s3.console.aws.amazon.com/s3/buckets/${aws_s3_bucket.ph-bucket.id}/wireguard/?region=${var.aws_region}&tab=overview"
}
