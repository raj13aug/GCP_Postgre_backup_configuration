
variable "gcp_pg_name_primary" {
  type    = string
  default = "postgresql-primary"
}

variable "gcp_pg_name_secondary" {
  type    = string
  default = "postgresql-secondary"
}

variable "gcp_pg_database_version" {
  type    = string
  default = "POSTGRES_15"
}

variable "gcp_pg_region_primary" {
  type    = string
  default = "us-central1"
}

variable "gcp_pg_region_secondary" {
  type    = string
  default = "europe-west1"
}

variable "project" {
  description = "The project ID where all resources will be launched."
  type        = string
  default     = "mytesting-400910"
}


variable "gcp_pg_tier" {
  type    = string
  default = "db-f1-micro"
}

variable "gcp_pg_db_flag_name" {
  type    = string
  default = "cloudsql.logical"
}

variable "gcp_pg_db_flag_value" {
  type    = string
  default = "on"
}

variable "backup_instance" {
  type    = string
  default = null
}

variable "backup_configuration" {
  description = "The backup_configuration settings subblock for the database setings"
  type = object({
    enabled                        = optional(bool, false)
    start_time                     = optional(string)
    location                       = optional(string)
    point_in_time_recovery_enabled = optional(bool, false)
    transaction_log_retention_days = optional(string)
    retained_backups               = optional(number)
    retention_unit                 = optional(string)
  })
  default = {}
}

variable "availability_type" {
  description = "only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`."
  type        = string
  default     = "ZONAL"
}