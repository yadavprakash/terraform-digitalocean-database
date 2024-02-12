output "id" {
  value = module.mysql.id
}

output "urn" {
  value = module.mysql.urn
}

output "host" {
  value = module.mysql.host
}

output "private_host" {
  value = module.mysql.private_host
}

output "port" {
  value = module.mysql.port
}

output "uri" {
  value     = module.mysql.uri
  sensitive = true
}

output "private_uri" {
  value     = module.mysql.private_uri
  sensitive = true
}

output "database" {
  value = module.mysql.database
}

output "user" {
  value = module.mysql.user
}

output "password" {
  value     = module.mysql.password
  sensitive = true
}