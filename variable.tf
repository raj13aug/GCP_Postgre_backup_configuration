
variable "gcp_pg_name_primary" {
  type    = string
  default = "postgresql-primary"
}


variable "gcp_pg_database_version" {
  type    = string
  default = "POSTGRES_15"
}

variable "gcp_pg_region_primary" {
  type    = string
  default = "us-central1"
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


variable "backup_configuration" {
  description = "(Optional) List of backup configurations."
  type        = any
  default = {
    enabled                        = true
    start_time                     = "00:00"
    binary_log_enabled             = false
    point_in_time_recovery_enabled = true
    transaction_log_retention_days = 2
    retained_backups               = 3
    retention_unit                 = "COUNT"
  }
}