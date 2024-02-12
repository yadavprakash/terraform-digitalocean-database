output "id" {
  value = module.mongodb.id
}

output "urn" {
  value = module.mongodb.urn
}

output "host" {
  value = module.mongodb.host
}

output "private_host" {
  value = module.mongodb.private_host
}

output "port" {
  value = module.mongodb.port
}

output "uri" {
  value     = module.mongodb.uri
  sensitive = true
}

output "private_uri" {
  value     = module.mongodb.private_uri
  sensitive = true
}

output "database" {
  value = module.mongodb.database
}

output "user" {
  value = module.mongodb.user
}

output "password" {
  value     = module.mongodb.password
  sensitive = true
}