output "dn" {
  value       = aci_rest.fileRemotePath.id
  description = "Distinguished name of `fileRemotePath` object."
}

output "name" {
  value       = aci_rest.fileRemotePath.content.name
  description = "Remote location name."
}
