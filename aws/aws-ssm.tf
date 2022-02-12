# pihole password as ssm parameter
resource "aws_ssm_parameter" "ph-ssm-param-pass" {
  name   = "${var.name_prefix}-pihole-web-password"
  type   = "SecureString"
  key_id = aws_kms_key.ph-kmscmk-ssm.key_id
  value  = var.pihole_password
}

# document to install deps and run playbook
resource "aws_ssm_document" "ph-ssm-doc" {
  name          = "${var.name_prefix}-ssm-doc"
  document_type = "Command"
  content       = <<DOC
  {
    "schemaVersion": "2.2",
    "description": "Ansible Playbooks via SSM for Ubuntu 18.04 ARM, installs Ansible properly.",
    "parameters": {
    "SourceType": {
      "description": "(Optional) Specify the source type.",
      "type": "String",
      "allowedValues": [
      "GitHub",
      "S3"
      ]
    },
    "SourceInfo": {
      "description": "Specify 'path'. Important: If you specify S3, then the IAM instance profile on your managed instances must be configured with read access to Amazon S3.",
      "type": "StringMap",
      "displayType": "textarea",
      "default": {}
    },
    "PlaybookFile": {
      "type": "String",
      "description": "(Optional) The Playbook file to run (including relative path). If the main Playbook file is located in the ./automation directory, then specify automation/playbook.yml.",
      "default": "hello-world-playbook.yml",
      "allowedPattern": "[(a-z_A-Z0-9\\-)/]+(.yml|.yaml)$"
    },
    "ExtraVariables": {
      "type": "String",
      "description": "(Optional) Additional variables to pass to Ansible at runtime. Enter key/value pairs separated by a space. For example: color=red flavor=cherry",
      "default": "SSM=True",
      "displayType": "textarea",
      "allowedPattern": "^$|^\\w+\\=[^\\s|:();&]+(\\s\\w+\\=[^\\s|:();&]+)*$"
    },
    "Verbose": {
      "type": "String",
      "description": "(Optional) Set the verbosity level for logging Playbook executions. Specify -v for low verbosity, -vv or vvv for medium verbosity, and -vvvv for debug level.",
      "allowedValues": [
      "-v",
      "-vv",
      "-vvv",
      "-vvvv"
      ],
      "default": "-v"
    }
    },
    "mainSteps": [
    {
      "action": "aws:downloadContent",
      "name": "downloadContent",
      "inputs": {
      "SourceType": "{{ SourceType }}",
      "SourceInfo": "{{ SourceInfo }}"
      }
    },
    {
      "action": "aws:runShellScript",
      "name": "runShellScript",
      "inputs": {
      "runCommand": [
        "#!/bin/bash",
        "# Ensure ansible is installed",
        "apt-get update",
        "DEBIAN_FRONTEND=noninteractive apt-get -y install python3-pip git",
        "pip3 install --upgrade pip",
        "pip3 install --upgrade ansible",
        "echo \"Running Ansible in `pwd`\"",
        "#this section locates files and unzips them",
        "for zip in $(find -iname '*.zip'); do",
        "  unzip -o $zip",
        "done",
        "PlaybookFile=\"{{PlaybookFile}}\"",
        "if [ ! -f  \"$${PlaybookFile}\" ] ; then",
        "   echo \"The specified Playbook file doesn't exist in the downloaded bundle. Please review the relative path and file name.\" >&2",
        "   exit 2",
        "fi",
        "ansible-playbook -i \"localhost,\" -c local -e \"{{ExtraVariables}}\" \"{{Verbose}}\" \"$${PlaybookFile}\""
      ]
      }
    }
    ]
  }
DOC
}

# ansible playbook association for tag:value cloudblock:True
resource "aws_ssm_association" "ph-ssm-assoc" {
  association_name = "${var.name_prefix}-ssm-assoc"
  name             = aws_ssm_document.ph-ssm-doc.name
  targets {
    key    = "tag:cloudblock"
    values = ["True"]
  }
  output_location {
    s3_bucket_name = aws_s3_bucket.ph-bucket.id
    s3_key_prefix  = "ssm"
  }
  parameters = {
    ExtraVariables = "SSM=True aws_region=${var.aws_region} name_prefix=${var.name_prefix} s3_bucket=${aws_s3_bucket.ph-bucket.id} kms_key_id=${aws_kms_key.ph-kmscmk-s3.key_id} docker_network=${var.docker_network} docker_gw=${var.docker_gw} docker_doh=${var.docker_doh} docker_pihole=${var.docker_pihole} docker_wireguard=${var.docker_wireguard} docker_webproxy=${var.docker_webproxy} wireguard_network=${var.wireguard_network} doh_provider=${var.doh_provider} dns_novpn=${var.dns_novpn} wireguard_peers=${var.wireguard_peers} vpn_traffic=${var.vpn_traffic}"
    PlaybookFile   = data.aws_ami.ph-vendor-ami-latest.architecture == "arm64" ? "cloudblock_aws_arm.yml" : "cloudblock_aws_amd64.yml"
    SourceInfo     = "{\"path\":\"https://s3.${var.aws_region}.amazonaws.com/${aws_s3_bucket.ph-bucket.id}/playbook/\"}"
    SourceType     = "S3"
    Verbose        = "-v"
  }
  depends_on = [aws_iam_role_policy_attachment.ph-iam-attach-ssm, aws_iam_role_policy_attachment.ph-iam-attach-s3, aws_s3_object.ph-files]
}
