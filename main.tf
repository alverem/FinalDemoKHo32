terraform {
  required_version = ">= 0.12"
 backend "gcs" {
   bucket  = "jenkins-instance"
   prefix  = "terraform/state"
   credentials = "<your-json>"
 }
}

#Here we define our provider, credentials via .json file, project, region and zone
provider "google" {
  credentials = file(var.creds)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

# We are creating our Compute Engine Instace
resource "google_compute_instance" "jenkins" {
  name         = var.inst-name
  machine_type = var.type                 #defining needed machine type
  tags         = ["http-server", "https-server"] #using tags to open http and https ports
  boot_disk {
    initialize_params {
      image = var.image
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
  metadata_startup_script = file("./jenkins.sh")
}
