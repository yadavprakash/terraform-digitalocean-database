##-----------------------------------------------------------------------------
#Description : labels module
##-----------------------------------------------------------------------------

module "labels" {
  source      = "git::https://github.com/opsstation/terraform-digitalocean-labels.git?ref=v1.0.0"
  name        = var.name
  environment = var.environment
  label_order = var.label_order
  #  tags     = var.tags
}

##----------------------------------------------------------------------------
#Description : resource by Digitalocean database cluster.
##-----------------------------------------------------------------------------

resource "digitalocean_database_cluster" "cluster" {
  count                = var.enabled == true ? 1 : 0
  name                 = format("%s-cluster", module.labels.id)
  engine               = var.cluster_engine
  version              = var.cluster_version
  size                 = var.cluster_size
  region               = var.region
  node_count           = var.cluster_node_count
  private_network_uuid = var.cluster_private_network_uuid
  tags                 = [module.labels.id]
  eviction_policy      = var.redis_eviction_policy
  sql_mode             = var.mysql_sql_mode

}

##-----------------------------------------------------------------------------
#Description : resource by Digitalocean database db.
##-----------------------------------------------------------------------------

resource "digitalocean_database_db" "database" {
  depends_on = [digitalocean_database_cluster.cluster]
  count      = var.enabled == true ? length(var.databases) : 0
  cluster_id = join("", digitalocean_database_cluster.cluster[*].id)
  name       = var.databases[count.index]
}

##-----------------------------------------------------------------------------
#Description : resource by Digitalocean database user.
##-----------------------------------------------------------------------------
resource "digitalocean_database_user" "user-example" {
  for_each          = var.enabled == true && var.users != null ? { for u in var.users : u.name => u } : {}
  cluster_id        = join("", digitalocean_database_cluster.cluster[*].id)
  name              = each.value.name
  mysql_auth_plugin = lookup(each.value, "password", null)
}

##-----------------------------------------------------------------------------
#Description : resource by Digitalocean database connection_pool.
##-----------------------------------------------------------------------------
resource "digitalocean_database_connection_pool" "pool-01" {
  for_each   = var.enabled == true && var.create_pools ? { for p in var.pools : p.name => p } : {}
  cluster_id = join("", digitalocean_database_cluster.cluster[*].id)
  name       = each.value.name
  mode       = each.value.mode
  size       = each.value.size
  db_name    = each.value.db_name
  user       = each.value.user
}

##-----------------------------------------------------------------------------
#Description : resource by Digitalocean database firewall.
##-----------------------------------------------------------------------------

resource "digitalocean_database_firewall" "example-fw" {
  count      = var.enabled == true && var.create_firewall ? 1 : 0
  cluster_id = join("", digitalocean_database_cluster.cluster[*].id)
  dynamic "rule" {
    for_each = var.firewall_rules
    content {
      type  = rule.value.type
      value = rule.value.value
    }

  }
  depends_on = [digitalocean_database_cluster.cluster]
}

##-----------------------------------------------------------------------------
#Description : resource by Digitalocean database replica.
##-----------------------------------------------------------------------------

resource "digitalocean_database_replica" "replica-example" {
  count      = var.enabled == true && var.replica_enable ? 1 : 0
  cluster_id = join("", digitalocean_database_cluster.cluster[*].id)
  name       = "replica-example"
  size       = var.cluster_size
  region     = var.region
  tags       = [module.labels.id]
}

##-----------------------------------------------------------------------------
#Description : resource by Digitalocean database firewall.
##-----------------------------------------------------------------------------

resource "digitalocean_database_firewall" "replica-firewall" {
  count      = var.enabled == true && var.create_firewall && var.replica_enable ? 1 : 0
  cluster_id = join("", digitalocean_database_cluster.cluster[*].id)
  dynamic "rule" {
    for_each = var.firewall_rules
    content {
      type  = rule.value.type
      value = rule.value.value
    }
  }
  depends_on = [digitalocean_database_cluster.cluster]
}