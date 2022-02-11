data "aws_availability_zones" "azs" {
  state = "available"
}
data "aws_ami" "nios" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "name"
    values = ["*NIOS ${var.nios_version}*"]
  }
}