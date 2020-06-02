provider "google" {
  #credentials = "service-account.json"
  credentials = "${var.credentials_file_path}"
  #project     = "terraform-teste-278718"
  project = "${var.project_name}"
  #region      = "southamerica-east1"
  region  = "${var.region}"
  #zone      = "southamerica-east1-b"
  zone = "${var.zone}"
}

resource "google_compute_firewall" "firewall-vm" {
   name    = "terraform-firewall"
   allow {
     protocol = "tcp"
     ports = ["80"]
   }
   source_tags = ["web"]
   source_ranges = ["0.0.0.0/0"]
   network = "default"
}

resource "google_compute_instance" "vm" {
  count = 3 
  name = "terraform-teste${count.index + 1}"
  machine_type = "g1-small"
  zone = "southamerica-east1-b"
  tags = ["servidor${count.index + 1}"]

   metadata_startup_script = "apt update && apt install nginx -y && service nginx restart"


  boot_disk {
    initialize_params {
      image = "${var.image_name}"
    }
  }
  network_interface {
    network = "default"
    access_config {
      network_tier = "STANDARD"
    }
  }

}
