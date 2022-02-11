# Infoblox NIOS Deployment on AWS Terraform module
This Terraform module creates an Infoblox NIOS appliance on AWS

## Module Functions
The module is meant to be modular and can create all or none of the prerequiste resources needed for the NIOS AWS Deployment including:
* VPC and Subnets for the Controller and SEs (configured with create_networking variable)
* IAM Roles, Policy, and Instance Profile (configured with create_iam variable)
* Security Groups for NIOS communication
* AWS EC2 Instance using an official Infoblox AMI

## Usage
This is an example of a NIOS deployment:
```hcl
terraform {
  backend "local" {
  }
}
module "nios_aws" {
  source  = "slarimore02/infoblox-deployment/aws"
  version = "1.0.0"

  region = "us-west-1"
  aws_access_key = "<access-key>"
  aws_secret_key = "<secret-key>"
  create_networking = "false"
  create_iam = "false"
  custom_vpc_id = "vpc-<id>"
  custom_subnet_ids = ["subnet-<id>","subnet-<id>"]
  device_password = "<newpassword>"
  key_pair_name = "<key>"
  name_prefix = "<name>"
  custom_tags = { "Role" : "NIOS", "Owner" : "admin", "Department" : "IT" }
}
output "controller_info" {
  value = module.nios_aws.nios_public_address
}
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.25.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 3.25.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ec2_tag.custom_tags](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_eip.mgmt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_iam_instance_profile.nios](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.vdiscovery](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_instance.nios](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.nios](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_network_interface.first](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_network_interface.second](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_interface) | resource |
| [aws_route.default_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_security_group.nios_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.nios_lan](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.nios_mgmt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.nios](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ami.nios](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_availability_zones.azs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | The Access Key that will be used to deploy AWS resources | `string` | n/a | yes |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | The Secret Key that will be used to deploy AWS resources | `string` | n/a | yes |
| <a name="input_boot_disk_size"></a> [boot\_disk\_size](#input\_boot\_disk\_size) | The boot disk size for the nios device | `number` | `250` | no |
| <a name="input_create_iam"></a> [create\_iam](#input\_create\_iam) | Create IAM Service Account, Roles, and Role Bindings for NIOS | `bool` | `"false"` | no |
| <a name="input_create_networking"></a> [create\_networking](#input\_create\_networking) | This variable controls the VPC and subnet creation for the nios device. When set to false the custom-vpc-name and custom-subnetwork-name must be set. | `bool` | `"true"` | no |
| <a name="input_custom_subnet_ids"></a> [custom\_subnet\_ids](#input\_custom\_subnet\_ids) | This field can be used to specify a list of 2 existing VPC Subnets for the NIOS device with the 1st being for mgmt and 2nd for LAN. The create-networking variable must also be set to false for this network to be used. | `list(string)` | `null` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Custom tags added to AWS Resources created by the module | `map(string)` | `{}` | no |
| <a name="input_custom_vpc_id"></a> [custom\_vpc\_id](#input\_custom\_vpc\_id) | This field can be used to specify an existing VPC for the device. The create-networking variable must also be set to false for this network to be used. | `string` | `null` | no |
| <a name="input_device_password"></a> [device\_password](#input\_device\_password) | The password that will be used authenticating with the nios device. This password be a minimum of 8 characters and contain at least one each of uppercase, lowercase, numbers, and special characters | `string` | n/a | yes |
| <a name="input_key_pair_name"></a> [key\_pair\_name](#input\_key\_pair\_name) | The name of the existing EC2 Key pair that will be used to authenticate to the nios device | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | This prefix is appended to the names of the device and SEs | `string` | n/a | yes |
| <a name="input_nios_cidr_block"></a> [nios\_cidr\_block](#input\_nios\_cidr\_block) | The CIDR that will be used for creating a subnet in the VPC when create\_network=true - a /16 should be provided | `string` | `"10.255.0.0/16"` | no |
| <a name="input_nios_version"></a> [nios\_version](#input\_nios\_version) | The nios device version that will be deployed | `string` | `"8.5.2"` | no |
| <a name="input_nios_vm_model"></a> [nios\_vm\_model](#input\_nios\_vm\_model) | The NIOS VM Model used for the deployment. https://docs.infoblox.com/display/NAIG/Infoblox+vNIOS+for+AWS+AMI+Shapes+and+Regions | `string` | `"TE-V825"` | no |
| <a name="input_public_address"></a> [public\_address](#input\_public\_address) | This variable controls if the device has a Public IP Address. When set to false the Ansible provisioner will connect to the private IP of the device. | `bool` | `"true"` | no |
| <a name="input_region"></a> [region](#input\_region) | The Region that the nios device and SEs will be deployed to | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nios_private_address"></a> [nios\_private\_address](#output\_nios\_private\_address) | The Private IP Addresses allocated for the NIOS |
| <a name="output_nios_public_address"></a> [nios\_public\_address](#output\_nios\_public\_address) | Public IP Addresses for the NIOS Device |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->