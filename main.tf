terraform {
  required_version = ">= 0.12"
 backend "gcs" {
   bucket  = "infrastructure-kh032"
   prefix  = "terraform/state"
   credentials = "finaldemokh032-e628298ba948.json"
 }
}

#Here we define our provider, credentials via .json file, project, region and zone
provider "google" {
  credentials = file(var.creds)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

resource "google_container_cluster" "cluster" {
  name               = var.cluster-name
  location           = var.zone
  initial_node_count = 4

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}
