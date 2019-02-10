variable "heroku_email" {}
variable "heroku_api_key" {}
variable "gcp_credential_file" {}

terraform {
  backend "gcs" {
    bucket = "complimentary-terraform-state"
    prefix = "moment-bot-trade"
  }
}

# Configure the Heroku provider
provider "heroku" {
  email   = "${var.heroku_email}"
  api_key = "${var.heroku_api_key}"
}

# Create a new application
resource "heroku_app" "moment-bot-trade" {
  name   = "moment-bot-trade"
  region = "us"
}

resource "heroku_addon" "redis" {
  app  = "${heroku_app.moment-bot-trade.name}"
  plan = "heroku-redis:hobby-dev"
}

# Google
provider "google" {
  project = "moment-bot-trade"
  region  = "us-central1"
  credentials = "${var.gcp_credential_file}"
}

resource "google_container_node_pool" "np" {
  name       = "gke-node-pool"
  zone       = "us-central1-a"
  cluster    = "${google_container_cluster.primary.name}"

  # NOTE: this value is recognized as multiple of enough number of CPUs that can form a node
  node_count = 1

  management {
    auto_repair = true
  }

  lifecycle {
    ignore_changes = ["node_pool"]
  }

  node_config {
    preemptible  = true
    machine_type = "f1-micro"
    disk_size_gb = 10
  }
}

resource "google_container_cluster" "primary" {
  name = "gke-cluster"
  zone = "us-central1-a"

  additional_zones = [
    "us-central1-b",
    "us-central1-c",
  ]

  node_pool {
    name = "np"
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }

    horizontal_pod_autoscaling {
      disabled = false
    }

    kubernetes_dashboard {
      disabled = false
    }
  }
}
