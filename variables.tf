variable "region" {
  description = "The Region that the nios device and SEs will be deployed to"
  type        = string
}
variable "aws_access_key" {
  description = "The Access Key that will be used to deploy AWS resources"
  type        = string
  sensitive   = true
}
variable "aws_secret_key" {
  description = "The Secret Key that will be used to deploy AWS resources"
  type        = string
  sensitive   = true
}
variable "key_pair_name" {
  description = "The name of the existing EC2 Key pair that will be used to authenticate to the nios device"
  type        = string
}
variable "nios_version" {
  description = "The nios device version that will be deployed"
  type        = string
  default     = "8.5.2"
}
variable "name_prefix" {
  description = "This prefix is appended to the names of the device and SEs"
  type        = string
}
variable "create_networking" {
  description = "This variable controls the VPC and subnet creation for the nios device. When set to false the custom-vpc-name and custom-subnetwork-name must be set."
  type        = bool
  default     = "true"
}
variable "public_address" {
  description = "This variable controls if the device has a Public IP Address. When set to false the Ansible provisioner will connect to the private IP of the device."
  type        = bool
  default     = "true"
}
variable "custom_vpc_id" {
  description = "This field can be used to specify an existing VPC for the device. The create-networking variable must also be set to false for this network to be used."
  type        = string
  default     = null
}
variable "custom_subnet_ids" {
  description = "This field can be used to specify a list of 2 existing VPC Subnets for the NIOS device with the 1st being for mgmt and 2nd for LAN. The create-networking variable must also be set to false for this network to be used."
  type        = list(string)
  default     = null
}
variable "nios_cidr_block" {
  description = "The CIDR that will be used for creating a subnet in the VPC when create_network=true - a /16 should be provided"
  type        = string
  default     = "10.255.0.0/16"
}
variable "create_iam" {
  description = "Create IAM Service Account, Roles, and Role Bindings for NIOS"
  type        = bool
  default     = "false"
}
variable "device_password" {
  description = "The password that will be used authenticating with the nios device. This password be a minimum of 8 characters and contain at least one each of uppercase, lowercase, numbers, and special characters"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.device_password) > 7
    error_message = "The device_password value must be more than 8 characters and contain at least one each of uppercase, lowercase, numbers, and special characters."
  }
}
variable "nios_vm_model" {
  description = "The NIOS VM Model used for the deployment. https://docs.infoblox.com/display/NAIG/Infoblox+vNIOS+for+AWS+AMI+Shapes+and+Regions"
  type        = string
  default     = "TE-V825"
}
variable "boot_disk_size" {
  description = "The boot disk size for the nios device"
  type        = number
  default     = 250
  validation {
    condition     = var.boot_disk_size >= 250
    error_message = "The device root disk size should be greater than or equal to 250 GB."
  }
}
variable "custom_tags" {
  description = "Custom tags added to AWS Resources created by the module"
  type        = map(string)
  default     = {}
}