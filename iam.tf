resource "aws_iam_role" "vdiscovery" {
  count              = var.create_iam ? 1 : 0
  name               = "${var.name_prefix}_NIOS-vDiscovery-Role"
  assume_role_policy = file("${path.module}/files/nios-vdiscovery.json")

  tags = var.custom_tags
}