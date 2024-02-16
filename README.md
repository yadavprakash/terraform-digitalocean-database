# Terraform Infrastructure as Code (IaC) - digitalocean database Module

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [Authors](#authors)
- [License](#license)

## Introduction
This Terraform module creates structured database for digitalocean resources with specific attributes.

## Usage

- Use the module by referencing its source and providing the required variables.
Example:Basic
```hcl
module "mysql" {
  source                       = "git::https://github.com/opsstation/terraform-digitalocean-database.git?ref=v1.0.0"
  name                         = "mysql-cluster"
  environment                  = "test"
  region                       = "nyc3"
  cluster_engine               = "mysql"
  cluster_version              = "8"
  cluster_size                 = "db-s-1vcpu-1gb"
  cluster_node_count           = 1
  cluster_private_network_uuid = module.vpc.id
  mysql_sql_mode               = "ANSI,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,STRICT_ALL_TABLES,ALLOW_INVALID_DATES"
}
```
Example:Complete

```hcl
module "mysql" {
source                       = "git::https://github.com/opsstation/terraform-digitalocean-database.git?ref=v1.0.0"
name                         = "mysql-cluster"
environment                  = "test"
region                       = "nyc3"
cluster_engine               = "mysql"
cluster_version              = "8"
cluster_size                 = "db-s-1vcpu-1gb"
cluster_node_count           = 1
cluster_private_network_uuid = module.vpc.id
mysql_sql_mode               = "ANSI,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,STRICT_ALL_TABLES,ALLOW_INVALID_DATES"
cluster_maintenance = {
day  = "monday"
hour = "01:00:00"
}

databases = ["testingdb"]
users = [
{
name              = "doadmin_test",
mysql_auth_plugin = "password"
}
]
create_firewall = false
firewall_rules = [
{
type  = "ip_addr"
value = "0.0.0.0"
}]
}
```

Example:mongodb
```hcl
module "mongodb" {
  source                       = "git::https://github.com/opsstation/terraform-digitalocean-database.git?ref=v1.0.0"
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
```

Example:mysql
```hcl
module "mysql" {
  source                       = "git::https://github.com/opsstation/terraform-digitalocean-database.git?ref=v1.0.0"
  name                         = "mysql-cluster"
  environment                  = "test"
  region                       = "nyc3"
  cluster_engine               = "mysql"
  cluster_version              = "8"
  cluster_size                 = "db-s-1vcpu-1gb"
  cluster_node_count           = 1
  cluster_private_network_uuid = module.vpc.id
  mysql_sql_mode               = "ANSI,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,STRICT_ALL_TABLES,ALLOW_INVALID_DATES"
  cluster_maintenance = {
    hour = "01:00:00"
    day  = "wednesday"
  }

  databases = ["testdb", "testdbt"]
  users = [
    {
      name              = "doadmin_test",
      mysql_auth_plugin = "password"
    }
  ]
  create_firewall = false
  firewall_rules = [
    {
      type  = "ip_addr"
      value = "0.0.0.0"
    }]
}
```

Example:postgresql
```hcl
module "postgresql" {
  source                       = "git::https://github.com/opsstation/terraform-digitalocean-database.git?ref=v1.0.0"
  name                         = "postgresql"
  environment                  = "test"
  region                       = "nyc3"
  cluster_engine               = "pg"
  cluster_version              = "15"
  cluster_size                 = "db-s-1vcpu-1gb"
  cluster_node_count           = 1
  cluster_private_network_uuid = module.vpc.id
  cluster_maintenance = {
    hour = "02:00:00"
    day  = "saturday"
  }
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
```
Example:redis
```hcl
module "redis" {
  source                       = "git::https://github.com/opsstation/terraform-digitalocean-database.git?ref=v1.0.0"
  name                         = "redis"
  environment                  = "test"
  region                       = "nyc3"
  cluster_engine               = "redis"
  cluster_version              = "7"
  cluster_size                 = "db-s-1vcpu-1gb"
  cluster_node_count           = 1
  cluster_private_network_uuid = module.vpc.id
  redis_eviction_policy        = "volatile_lru"
  cluster_maintenance = {
    hour = "01:00:00"
    day  = "tuesday"
  }
  create_firewall = true
  firewall_rules = [
    {
      type  = "ip_addr"
      value = "0.0.0.0"

    }]
}
```

Example:replica_db
```hcl
module "mysql" {
  source                       = "git::https://github.com/opsstation/terraform-digitalocean-database.git?ref=v1.0.0"
  name                         = "mysql-cluster"
  environment                  = "test"
  region                       = "nyc3"
  cluster_engine               = "mysql"
  cluster_version              = "8"
  cluster_size                 = "db-s-1vcpu-1gb"
  cluster_node_count           = 1
  cluster_private_network_uuid = module.vpc.id
  mysql_sql_mode               = "ANSI,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,STRICT_ALL_TABLES,ALLOW_INVALID_DATES"
  cluster_maintenance = {
    hour = "01:00:00"
    day  = "wednesday"
  }

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
```
Please ensure you specify the correct 'source' path for the module.

## Module Inputs

- `name`: The name of the application.
- `environment`: The environment (e.g., "test", "production").
- `label_order`: Label order, e.g. `name`,`application`.
- `enabled`: Flag to control the database creation.
- `cluster_private_network_uuid`: The ID of the VPC where the database cluster will be located.
- `mysql_sql_mode` : A comma separated string specifying the SQL modes for a MySQL cluster.
- `cluster_node_count`: Number of nodes that will be included in the cluster.
- `redis_eviction_policy`: A string specifying the eviction policy for a Redis cluster. Valid values are: noeviction, allkeys_lru, allkeys_random, volatile_lru, volatile_random, or volatile_ttl.
- `databases`: A list of databases in the cluster.

## Module Outputs
- This module currently does not provide any outputs.

# Examples:Basic
For detailed examples on how to use this module, please refer to the '[example](https://github.com/opsstation/terraform-digitalocean-database/tree/master/_example/basic)' directory within this repository.
# Examples:complete
For detailed examples on how to use this module, please refer to the '[example](https://github.com/opsstation/terraform-digitalocean-database/tree/master/_example/complete)' directory within this repository.
# Examples:mongodb
For detailed examples on how to use this module, please refer to the '[example](https://github.com/opsstation/terraform-digitalocean-database/tree/master/_example/mongodb)' directory within this repository.
# Examples:mysql
For detailed examples on how to use this module, please refer to the '[example](https://github.com/opsstation/terraform-digitalocean-database/tree/master/_example/mysql)' directory within this repository.
# Examples:postgresql
For detailed examples on how to use this module, please refer to the '[example](https://github.com/opsstation/terraform-digitalocean-database/tree/master/_example/postgresql)' directory within this repository.
# Examples:redis
For detailed examples on how to use this module, please refer to the '[example](https://github.com/opsstation/terraform-digitalocean-database/tree/master/_example/redis)' directory within this repository.
# Examples:replica_db
For detailed examples on how to use this module, please refer to the '[example](https://github.com/opsstation/terraform-digitalocean-database/tree/master/_example/replica_db)' directory within this repository.

## Authors
Your Name
Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/opsstation/terraform-digitalocean-database/blob/master/LICENSE) file for details.



<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | >= 2.34.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | >= 2.34.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | git::https://github.com/opsstation/terraform-digitalocean-labels.git | v1.0.0 |

## Resources

| Name | Type |
|------|------|
| [digitalocean_database_cluster.cluster](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_cluster) | resource |
| [digitalocean_database_connection_pool.pool-01](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_connection_pool) | resource |
| [digitalocean_database_db.database](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_db) | resource |
| [digitalocean_database_firewall.example-fw](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_firewall) | resource |
| [digitalocean_database_firewall.replica-firewall](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_firewall) | resource |
| [digitalocean_database_replica.replica-example](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_replica) | resource |
| [digitalocean_database_user.user-example](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/database_user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_engine"></a> [cluster\_engine](#input\_cluster\_engine) | Database engine used by the cluster (ex. pg for PostreSQL, mysql for MySQL, redis for Redis, or mongodb for MongoDB) | `string` | `""` | no |
| <a name="input_cluster_node_count"></a> [cluster\_node\_count](#input\_cluster\_node\_count) | Number of nodes that will be included in the cluster. | `number` | `1` | no |
| <a name="input_cluster_private_network_uuid"></a> [cluster\_private\_network\_uuid](#input\_cluster\_private\_network\_uuid) | The ID of the VPC where the database cluster will be located | `string` | `null` | no |
| <a name="input_cluster_size"></a> [cluster\_size](#input\_cluster\_size) | Database Droplet size associated with the cluster (ex. db-s-1vcpu-1gb) | `string` | `""` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | The version of the cluster | `string` | `""` | no |
| <a name="input_create_firewall"></a> [create\_firewall](#input\_create\_firewall) | Controls if firewall should be created | `bool` | `false` | no |
| <a name="input_create_pools"></a> [create\_pools](#input\_create\_pools) | Controls if pools should be created | `bool` | `false` | no |
| <a name="input_databases"></a> [databases](#input\_databases) | A list of databases in the cluster | `list(string)` | `[]` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Flag to control the resources creation. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_firewall_rules"></a> [firewall\_rules](#input\_firewall\_rules) | List of firewall rules associated with the cluster | `list(map(string))` | `[]` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. `name`,`application`. | `list(string)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_mysql_sql_mode"></a> [mysql\_sql\_mode](#input\_mysql\_sql\_mode) | A comma separated string specifying the SQL modes for a MySQL cluster. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the database cluster. | `string` | `""` | no |
| <a name="input_pools"></a> [pools](#input\_pools) | A list of connection pools in the cluster | `list(map(string))` | `null` | no |
| <a name="input_redis_eviction_policy"></a> [redis\_eviction\_policy](#input\_redis\_eviction\_policy) | A string specifying the eviction policy for a Redis cluster. Valid values are: noeviction, allkeys\_lru, allkeys\_random, volatile\_lru, volatile\_random, or volatile\_ttl | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | DigitalOcean region where the cluster will reside. | `string` | `""` | no |
| <a name="input_replica_enable"></a> [replica\_enable](#input\_replica\_enable) | Flag to control the resources creation. | `bool` | `false` | no |
| <a name="input_users"></a> [users](#input\_users) | A list of users in the cluster | `list(map(string))` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database"></a> [database](#output\_database) | Name of the cluster's default database. |
| <a name="output_host"></a> [host](#output\_host) | Database cluster's hostname. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the database cluster. |
| <a name="output_password"></a> [password](#output\_password) | Password for the cluster's default user. |
| <a name="output_port"></a> [port](#output\_port) | Network port that the database cluster is listening on. |
| <a name="output_private_host"></a> [private\_host](#output\_private\_host) | Same as host, but only accessible from resources within the account and in the same region. |
| <a name="output_private_uri"></a> [private\_uri](#output\_private\_uri) | Same as uri, but only accessible from resources within the account and in the same region. |
| <a name="output_uri"></a> [uri](#output\_uri) | The full URI for connecting to the database cluster. |
| <a name="output_urn"></a> [urn](#output\_urn) | The uniform resource name of the database cluster. |
| <a name="output_user"></a> [user](#output\_user) | Username for the cluster's default user. |
<!-- END_TF_DOCS -->