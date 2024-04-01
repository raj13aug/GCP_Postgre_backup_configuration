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

resource "google_sql_database_instance" "primary" {
  name                = var.gcp_pg_name_primary
  database_version    = var.gcp_pg_database_version
  region              = var.gcp_pg_region_primary
  deletion_protection = false


  settings {
    tier = var.gcp_pg_tier
  }

  depends_on = [google_project_service.services, time_sleep.wait_30_seconds]

}

resource "google_sql_database_instance" "secondary" {
  name                = var.gcp_pg_name_secondary
  database_version    = var.gcp_pg_database_version
  region              = var.gcp_pg_region_secondary
  deletion_protection = false

  master_instance_name = google_sql_database_instance.primary.name

  settings {
    tier = var.gcp_pg_tier
  }
}

output "instance_primary_ip_address" {
  value = google_sql_database_instance.primary.ip_address
}

output "instance_secondary_ip_address" {
  value = google_sql_database_instance.secondary.ip_address
}
