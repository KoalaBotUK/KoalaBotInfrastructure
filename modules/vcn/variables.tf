
variable "cidr_block" {
  type = string
  description = "CIDR block of the VCN"
  default = "10.0.0.0/16"
}


variable "env" {
  description = "The display name prefix of the infrastructure resources"
  type        = string
}


variable "compartment_ocid" {
  type = string
  description = "The compartment to deploy the instance in"
}

