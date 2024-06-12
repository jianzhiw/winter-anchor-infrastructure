terraform {
    backend "gcs" {
        bucket = "gcs_terraform_prod"
        prefix = "state"
    }
}

provider "google" {
    project = "winter-anchor-259905"
    region = "us-central1"
}
