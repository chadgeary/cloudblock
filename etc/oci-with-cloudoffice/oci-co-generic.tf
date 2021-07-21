variable "co_oci_imageid" {
  type                     = string
  description              = "An OCID of an image, the playbook is compatible with Ubuntu 18.04+ minimal"
}

variable "co_oci_instance_shape" {
  type                     = string
  description              = "The size of the compute instance, only certain sizes are free-tier"
}

variable "co_oci_instance_diskgb" {
  type                     = string
  description              = "Size of system boot disk, in gb"
}

variable "co_oci_instance_memgb" {
  type                     = string
  description              = "Memory GB(s) for instance"
  default                  = 1
}

variable "co_oci_instance_ocpus" {
  type                     = string
  description              = "Oracle CPUs for instance"
  default                  = 1
}

variable "nc_prefix" {
  type                     = string
  description              = "A friendly prefix (like 'pihole') affixed to many resources, like the bucket name."
}

variable "admin_password" {
  type                     = string
  description              = "Password for WebUI access"
}

variable "db_password" {
  type                     = string
  description              = "Nextcloud application db password"
}

variable "oo_password" {
  type                     = string
  description              = "Nextcloud application onlyoffice password"
}

variable "co_project_url" {
  type                     = string
  description              = "URL of the git project"
}

variable "co_docker_network" {
  type                     = string
  description              = "docker network ip"
}

variable "co_docker_gw" {
  type                     = string
  description              = "docker network gateway ip"
}

variable "co_docker_nextcloud" {
  type                     = string
  description              = "nextcloud app container ip"
}

variable "co_docker_webproxy" {
  type                     = string
  description              = "https web proxy container ip"
}

variable "co_docker_db" {
  type                     = string
  description              = "db container ip"
}

variable "co_docker_onlyoffice" {
  type                     = string
  description              = "onlyoffice container"
}

variable "co_docker_duckdnsupdater" {
  type        = string
  description = "duckdns dynamic dns update container ip"
}

variable "project_directory" {
  type                     = string
  description              = "Location to install/run project"
  default                  = "/opt"
}

variable "web_port" {
  type                     = string
  description              = "Port to run web proxy"
  default                  = "443"
}

variable "oo_port" {
  type                     = string
  description              = "Port to run onlyoffice"
  default                  = "8443"
}

variable "enable_duckdns" {
  type = number
}

variable "duckdns_domain" {
  type = string
}

variable "duckdns_token" {
  type = string
}

variable "letsencrypt_email" {
  type = string
}

