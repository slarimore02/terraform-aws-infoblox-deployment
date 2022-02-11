locals {
  nios_vm_model = {
    "TE-V825"  = "r4.large",
    "TE-V1425" = "r3.xlarge"
    "TE-V2225" = "r4.2xlarge"
  }
  nios_license = {
    "TE-V825"  = "IB-V825",
    "TE-V1425" = "IB-V1425"
    "TE-V2225" = "IB-V2225"
  }
}

resource "aws_iam_instance_profile" "nios" {
  count = var.create_iam ? 1 : 0
  name  = "${var.name_prefix}_nios_iam_profile"
  role  = aws_iam_role.vdiscovery[0].id
}

resource "aws_instance" "nios" {
  ami = data.aws_ami.nios.id
  root_block_device {
    volume_size           = var.boot_disk_size
    delete_on_termination = true
  }
  instance_type = local.nios_vm_model[var.nios_vm_model]
  key_name      = var.key_pair_name
  network_interface {
    network_interface_id = aws_network_interface.first.id
    device_index         = 0
  }
  network_interface {
    network_interface_id = aws_network_interface.second.id
    device_index         = 1
  }
  iam_instance_profile = var.create_iam ? aws_iam_instance_profile.nios[0].id : null
  tags = {
    Name = "${var.name_prefix}-infoblox-nios"
  }
  user_data = <<EOF
#infoblox-config
remote_console_enabled: y
default_admin_password: "${var.device_password}"
temp_license: enterprise dns dhcp rpz cloud cloud_api nios "${local.nios_license[var.nios_vm_model]}"
EOF
  lifecycle {
    ignore_changes = [tags]
  }
}
resource "aws_ec2_tag" "custom_tags" {
  for_each    = var.custom_tags
  resource_id = aws_instance.nios.id
  key         = each.key
  value       = each.value
}