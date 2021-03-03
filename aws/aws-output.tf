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

#############
## UPDATES ##
#############

# SSH to the server
ssh ubuntu@${aws_eip.ph-eip-1.public_ip}

# Remove the old containers and exit SSH (service is down until completion of next step!)
sudo docker rm -f cloudflared_doh pihole web_proxy wireguard && exit

# Use AWS CLI to re-run SSM association (ansible playbook) 
~/.local/bin/aws ssm start-associations-once --region ${var.aws_region} --association-ids ${aws_ssm_association.ph-ssm-assoc.association_id}

#############
## DESTROY ##
#############

# To destroy the project via terraform, run:
terraform destroy -var-file="aws.tfvars"

OUTPUT
}
