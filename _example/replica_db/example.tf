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
#Description : module by Digitalocean mysql.
##-----------------------------------------------------------------------------

module "mysql" {
  source                       = "../.."
  name                         = "mysql-cluster"
  environment                  = "test"
  region                       = "nyc3"
  cluster_engine               = "mysql"
  cluster_version              = "8"
  cluster_size                 = "db-s-1vcpu-1gb"
  cluster_node_count           = 1
  cluster_private_network_uuid = module.vpc.id
  mysql_sql_mode               = "ANSI,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,STRICT_ALL_TABLES,ALLOW_INVALID_DATES"
  #  cluster_maintenance = {
  #    hour = "01:00:00"
  #    day  = "wednesday"
  #  }

  databases = ["testingdb1", "testingdb2"]
  users = [
    {
      name              = "doadmin_test",
      mysql_auth_plugin = "password"
    }
  ]
  ###### replica_database #######
  replica_enable = true

  ############ firewall  ########
  create_firewall = true
  firewall_rules = [
    {
      type  = "ip_addr"
      value = "0.0.0.0"
  }]
}
