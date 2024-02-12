##-----------------------------------------------------------------------------
#Description : provider by Digitalocean.
##-----------------------------------------------------------------------------
provider "digitalocean" {

}

##-----------------------------------------------------------------------------
#Description : module by Digitalocean vpc.
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
#Description : module by Digitalocean momgodb.
##-----------------------------------------------------------------------------

module "mongodb" {
  source                       = "../../"
  name                         = "mongo-cluster"
  environment                  = "test"
  region                       = "nyc3"
  cluster_engine               = "mongodb"
  cluster_version              = "6"
  cluster_size                 = "db-s-1vcpu-1gb"
  cluster_node_count           = 1
  cluster_private_network_uuid = module.vpc.id
  cluster_maintenance = {
    hour = "01:00:00"
    day  = "friday"
  }
  databases = ["testdb"]
  users = [
    {
      name = "test"
    }
  ]
}
