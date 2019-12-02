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

resource "google_compute_instance" "kh032" {
  name         = "kh032"
  machine_type = "n1-standard-1"                 #defining needed machine type
  tags         = ["http-server", "https-server"] #using tags to open http and https ports
  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-8-v20191115"
    }
  }
  service_account {
    scopes = ["cloud-platform"] #giving our instace access to all APIs
  }
  network_interface {
    network = "default" #here we specify VPC
    access_config {     #this block gives our instance external ip
    }
  }
}

resource "google_container_cluster" "cluster" {
  name               = var.cluster-name
  location           = var.zone
  initial_node_count = 3

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}
