variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "vcn_ocid" {}
variable "igw_ocid" {}
variable "rt_ocid" {}
variable "dhcp_options_ocid" {}
variable "security_list_ocid" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}

variable "compartment_name" {
  default = "Abhi-sandbox"
}

variable "AppShape" {
  description = "Shape of the App instances"
  default     = "VM.Standard1.2"
}

# variable "MysqlDBShape" {
#   description = "Shape of MySQL DB instances"
#   default     = "VM.DenseIO1.4"
# }

variable "HostUserName" {
  default = "ubuntu"
}

variable "InstanceImageOCID" {
  type        = "map"
  description = "Oracle image OCIDs"

  default = {
    // Oracle-provided image "Oracle-Linux-7.4-2017.12.18-0"
    // See https://docs.us-phoenix-1.oraclecloud.com/Content/Resources/Assets/OracleProvidedImageOCIDs.pdf
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaah2ngeqibr2xpe3sbco3po73qz5qw6bb574brp6cmfdwhc24y6toa"

    us-ashburn-1 = "ocid1.image.oc1.iad.aaaaaaaan3m7jn3f5dqsw5mzkabyudsxsf7ciy27j3fm4tjokij7r32hxwta"
  }
}

# variable "VCN-CIDR" {
#   description = ""
#   default     = "10.0.0.0/16"
# }

variable "PubSubnetAD1CIDR" {
  default = "192.168.4.0/24"
}

variable "PubSubnetAD2CIDR" {
  default = "192.168.5.0/24"
}
