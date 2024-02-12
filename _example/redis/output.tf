output "id" {
  value = module.redis.id
}

output "urn" {
  value = module.redis.urn
}

output "host" {
  value = module.redis.host
}

output "private_host" {
  value = module.redis.private_host
}

output "port" {
  value = module.redis.port
}

output "uri" {
  value     = module.redis.uri
  sensitive = true
}

output "private_uri" {
  value     = module.redis.private_uri
  sensitive = true
}

output "database" {
  value = module.redis.database
}

output "user" {
  value = module.redis.user
}

output "password" {
  value     = module.redis.password
  sensitive = true
}