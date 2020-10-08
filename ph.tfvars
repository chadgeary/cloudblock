# aws profile (e.g. from aws configure, usually "default")
aws_profile = "default"
aws_region = "us-east-1"

# the ip subnet permitted to connect to pihole's SSH/WebGUI and DNS if dns_novpn = 1
mgmt_cidr = "a.b.c.d/32"
dns_novpn = 1

# the ip subnet permitted to connect to the wireguard vpn for encrypted DNS, default is world (enrollment still required).
vpn_cidr = "0.0.0.0/0"

# a unique bucket name to store various input/output
bucket_name = "my-pihole-bucket1"

# existing aws iam user granted access to the kms key (for browsing KMS encrypted services like S3 or SNS).
kms_manager = "some_username"

# public ssh key
instance_key = "ssh-rsa AAAAB3NzaD2yc2EAAAADAQABAAABAQCNsxnMWfrG3SoLr4uJMavf43YkM5wCbdO7X5uBvRU8oh1W+A/Nd/jie2tc3UpwDZwS3w6MAfnu8B1gE9lzcgTu1FFf0us5zIWYR/mSoOFKlTiaI7Uaqkc+YzmVw/fy1iFxDDeaZfoc0vuQvPr+LsxUL5UY4ko4tynCSp7zgVpot/OppqdHl5J+DYhNubm8ess6cugTustUZoDmJdo2ANQENeBUNkBPXUnMO1iulfNb6GnwWJ0Z5TRRLGSu2gya2wMLeo1rBJ5cbZZgVLMVHiKgwBy/svUQreR8R+fpVW+Q4rx6sPAltLaOUONn0SF2BvvJUu_REPLACE_REPLACEME_REPLACEME"

# size according to workloads, ARM-based, t4g.nano is sufficient.
instance_type = "t4g.small"

# the root block size of the instance (in GiB), suggest minimum 30
instance_vol_size = 30

# the name prefix for the AMI, instance, etc.
ec2_name_prefix = "ph"

# the vendor supplying the AMI and the AMI name - default is official Ubuntu 18.04 ARM - note the date may need to be changed.
# list amis via AWS CLI with:
# aws ec2 describe-images --owners 099720109477 --filters 'Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-arm64-server-*' 'Name=state,Values=available'
vendor_ami_account_number = "099720109477"
vendor_ami_name_string = "ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-arm64-server-20200922"

# vpc specific vars, modify these values if there would be overlap with existing resources in the aws account.
vpc_cidr = "10.10.12.0/24"
pubnet_cidr = "10.10.12.0/26"
pubnet_instance_ip = "10.10.12.5"

# ssm ansible playbook specific vars 
ssm_web_password = "changeme"
