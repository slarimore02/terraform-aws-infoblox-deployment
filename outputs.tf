output "nios_public_address" {
  description = "Public IP Addresses for the NIOS Device"
  value       = aws_eip.mgmt[0].public_ip
}
output "nios_private_address" {
  description = "The Private IP Addresses allocated for the NIOS"
  value       = aws_instance.nios.private_ip
}