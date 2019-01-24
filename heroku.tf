variable "heroku_email" {}
variable "heroku_api_key" {}
variable "gcs_credential_file" {}

terraform {
  backend "gcs" {
    bucket  = "complimentary-terraform-state"
    prefix  = "moment-bot-trade"
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
