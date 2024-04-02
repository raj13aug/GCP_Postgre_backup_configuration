resource "google_project_service" "services" {
  project            = var.project
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sql-component" {
  project            = var.project
  service            = "sql-component.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "servicenetworking" {
  project            = var.project
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [google_project_service.services, google_project_service.sql-component, google_project_service.servicenetworking]

  create_duration = "30s"
}

locals {
  backup_configuration = length(var.backup_configuration) > 0 ? [var.backup_configuration] : []
}


resource "google_sql_database_instance" "primary" {
  name                = var.gcp_pg_name_primary
  database_version    = var.gcp_pg_database_version
  region              = var.gcp_pg_region_primary
  deletion_protection = false

  settings {
    tier      = var.gcp_pg_tier
    disk_size = 10
    disk_type = "PD_SSD"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "all_networks"
        value = "0.0.0.0/0"
      }
    }

    dynamic "backup_configuration" {
      for_each = local.backup_configuration

      content {
        enabled                        = try(backup_configuration.value.enabled, null)
        binary_log_enabled             = try(backup_configuration.value.binary_log_enabled, null)
        start_time                     = try(backup_configuration.value.start_time, null)
        point_in_time_recovery_enabled = try(backup_configuration.value.point_in_time_recovery_enabled, null)
        location                       = try(backup_configuration.value.location, null)
        transaction_log_retention_days = try(backup_configuration.value.transaction_log_retention_days, null)

        dynamic "backup_retention_settings" {
          for_each = try(backup_configuration.value.backup_retention_settings, [])

          content {
            retained_backups = try(backup_retention_settings.value.retained_backups, null)
            retention_unit   = try(backup_retention_settings.value.retention_unit, "COUNT")
          }
        }
      }
    }
  }
  depends_on = [google_project_service.services, time_sleep.wait_30_seconds]
}

output "instance_primary_ip_address" {
  value = google_sql_database_instance.primary.ip_address
}

