
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