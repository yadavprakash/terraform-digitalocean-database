output "id" {
  value = module.postgresql.id
}

output "urn" {
  value = module.postgresql.urn
}

output "host" {
  value = module.postgresql.host
}

output "private_host" {
  value = module.postgresql.private_host
}

output "port" {
  value = module.postgresql.port
}

output "uri" {
  value     = module.postgresql.uri
  sensitive = true
}

output "private_uri" {
  value     = module.postgresql.private_uri
  sensitive = true
}

output "database" {
  value = module.postgresql.database
}

output "user" {
  value = module.postgresql.user
}

output "password" {
  value     = module.postgresql.password
  sensitive = true
}