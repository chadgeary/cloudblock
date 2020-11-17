output "ssh-msg" {
  value                   = "SSH via: ssh ubuntu@${aws_eip.ph-eip-1.public_ip}"
}

output "pihole-web-msg" {
  value                   = "pihole WebUI will be available @ https://${aws_eip.ph-eip-1.public_ip}/admin/"
}

output "pihole-web-vpn-msg" {
  value                   = "pihole webUI also available (when on Wireguard VPN) @ https://${var.docker_webproxy}/admin/"
}

output "ph-wireguard-msg" {
  value                   = "Wireguard confs (one per device!) will be available @ https://s3.console.aws.amazon.com/s3/buckets/${aws_s3_bucket.ph-bucket.id}/wireguard/?region=${var.aws_region}&tab=overview"
}
