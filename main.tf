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
  backup_instance                = var.backup_instance != null
  backups_enabled                = var.availability_type == "ZONAL" ? lookup(var.backup_configuration, "enabled", true) : lookup(var.backup_configuration, "enabled", false)
  point_in_time_recovery_enabled = var.availability_type == "ZONAL" ? lookup(var.backup_configuration, "point_in_time_recovery_enabled", true) : lookup(var.backup_configuration, "point_in_time_recovery_enabled", false)
  retention_unit                 = lookup(var.backup_configuration, "retention_unit", COUNT)
  retained_backups               = lookup(var.backup_configuration, "retained_backups", 30)

}


resource "google_sql_database_instance" "primary" {
  name                = var.gcp_pg_name_primary
  database_version    = var.gcp_pg_database_version
  region              = var.gcp_pg_region_primary
  deletion_protection = false


  settings {
    tier = var.gcp_pg_tier

    dynamic "backup_configuration" {
      for_each = local.backup_instance ? [] : [var.backup_configuration]
      content {
        enabled                        = local.backups_enabled
        start_time                     = lookup(backup_configuration.value, "start_time", "20:55")
        location                       = lookup(backup_configuration.value, "location", null)
        point_in_time_recovery_enabled = local.point_in_time_recovery_enabled
        transaction_log_retention_days = lookup(backup_configuration.value, "transaction_log_retention_days", 1)

        dynamic "backup_retention_settings" {
          for_each = local.retained_backups != null || local.retention_unit != null ? [var.backup_configuration] : []
          content {
            retained_backups = local.retained_backups
            retention_unit   = local.retention_unit
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
