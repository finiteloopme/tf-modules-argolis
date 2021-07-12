terraform {
  required_version = ">= 0.14.8"
  required_providers {
    google = {
      source = "hashicorp/google"
      version     = "~> 3.64.0"
    }
    google-beta = {
      source = "hashicorp/google-beta"
      version     = "~> 3.64.0"
    }
    null = {
      source = "hashicorp/null"
      version = "~> 2.1"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 2.2"
    }
  }
}