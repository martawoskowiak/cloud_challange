provider "google" {
  project = "seismic-vista-378120"
  region  = "us-central1"
  zone    = "us-central1-c"
}

# Make bucket public
resource "google_storage_bucket_iam_member" "member" {
  provider = google
  bucket   = "marta-static-website"
  role     = "roles/storage.objectViewer"
  member   = "allUsers"
}

resource "google_storage_bucket" "static-site" {
  name          = "marta-static-website"
  location      = "EU"
  force_destroy = true
  source = "index.html"

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}
 
 resource "google_compute_instance" "vm-tf" {
  name         = "marta-vm-tf"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      labels = {
        managed_by_terraform = "true"
      }
    }
  }
  network_interface {
    network = "default"
    access_config {

      // Ephemeral public IP

    }
   }
 }
 
 resource "google_sql_database_instance" "main" {
  name             = "main-instance-marta"
  database_version = "POSTGRES_14"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_user" "users" {
  name     = "dareit_user"
  password = "pies123"
  instance = "main-instance-marta"
}

resource "google_sql_database" "database" {
  name     = "dareit"
  instance = "main-instance-marta"
}