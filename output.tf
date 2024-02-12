output "id" {
  value       = join("", digitalocean_database_cluster.cluster[*].id)
  description = "The ID of the database cluster."
}

output "urn" {
  value       = join("", digitalocean_database_cluster.cluster[*].urn)
  description = "The uniform resource name of the database cluster."
}

output "host" {
  value       = join("", digitalocean_database_cluster.cluster[*].host)
  description = "Database cluster's hostname."
}

output "private_host" {
  value       = join("", digitalocean_database_cluster.cluster[*].private_host)
  description = "Same as host, but only accessible from resources within the account and in the same region."
}

output "port" {
  value       = join("", digitalocean_database_cluster.cluster[*].port)
  description = "Network port that the database cluster is listening on."
}

output "uri" {
  value       = join("", digitalocean_database_cluster.cluster[*].uri)
  description = "The full URI for connecting to the database cluster."
}

output "private_uri" {
  value       = join("", digitalocean_database_cluster.cluster[*].private_uri)
  description = "Same as uri, but only accessible from resources within the account and in the same region."
}

output "database" {
  value       = join("", digitalocean_database_cluster.cluster[*].database)
  description = "Name of the cluster's default database."
}

output "user" {
  value       = join("", digitalocean_database_cluster.cluster[*].user)
  description = "Username for the cluster's default user."
}

output "password" {
  value       = join("", digitalocean_database_cluster.cluster[*].password)
  description = "Password for the cluster's default user."
}
