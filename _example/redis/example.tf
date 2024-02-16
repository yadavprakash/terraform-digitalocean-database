##-----------------------------------------------------------------------------
#Description : provider by Digitalocean.
##-----------------------------------------------------------------------------

provider "digitalocean" {

}

##-----------------------------------------------------------------------------
#Description : module by Digitalocean  vpc.
##-----------------------------------------------------------------------------

module "vpc" {
  source      = "git::https://github.com/opsstation/terraform-digitalocean-vpc.git?ref=v1.0.0"
  name        = "test-network"
  environment = "test"
  label_order = ["name", "environment"]
  region      = "nyc3"
  ip_range    = "10.10.0.0/24"

}

##-----------------------------------------------------------------------------
#Description : module by Digitalocean  redis.
##-----------------------------------------------------------------------------

module "redis" {
  source                       = "../../"
  name                         = "redis"
  environment                  = "test"
  region                       = "nyc3"
  cluster_engine               = "redis"
  cluster_version              = "7"
  cluster_size                 = "db-s-1vcpu-1gb"
  cluster_node_count           = 1
  cluster_private_network_uuid = module.vpc.id
  redis_eviction_policy        = "volatile_lru"
  #  cluster_maintenance = {
  #    hour = "01:00:00"
  #    day  = "tuesday"
  #  }
  create_firewall = true
  firewall_rules = [
    {
      type  = "ip_addr"
      value = "0.0.0.0"

  }]
}