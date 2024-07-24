##-----------------------------------------------------------------------------
#Description : provider by Digitalocean.
##-----------------------------------------------------------------------------

provider "digitalocean" {

}

##-----------------------------------------------------------------------------
#Description : module by Digitalocean  vpc.
##-----------------------------------------------------------------------------

module "vpc" {
  source      = "git::https://github.com/yadavprakash/terraform-digitalocean-vpc.git?ref=v1.0.0"
  name        = "test-network"
  environment = "test"
  label_order = ["name", "environment"]
  region      = "nyc3"
  ip_range    = "10.10.0.0/24"

}

##-----------------------------------------------------------------------------
#Description : module by Digitalocean  postgresql.
##-----------------------------------------------------------------------------

module "postgresql" {
  source                       = "../../"
  name                         = "postgresql"
  environment                  = "test"
  region                       = "nyc3"
  cluster_engine               = "pg"
  cluster_version              = "15"
  cluster_size                 = "db-s-1vcpu-1gb"
  cluster_node_count           = 1
  cluster_private_network_uuid = module.vpc.id
  #  cluster_maintenance = {
  #    hour = "02:00:00"
  #    day  = "saturday"
  #  }
  databases = ["testingdb"]
  users = [
    {
      name = "test"
    }
  ]
  create_pools = true
  pools = [
    {
      name    = "test-01"
      mode    = "transaction"
      size    = 20
      db_name = "defaultdb"
      user    = "doadmin"
    }
  ]
  create_firewall = false
  firewall_rules = [
    {
      type  = "127.0.0.1"
      value = "0.0.0.0"
    }
  ]
}
