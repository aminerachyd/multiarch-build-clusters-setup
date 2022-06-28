terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

provider "kubernetes" {
  alias    = "dev-cluster"
  host     = var.dev-cluster-host
  token    = var.dev-cluster-token
  insecure = true
}

provider "kubernetes" {
  alias    = "z-cluster"
  host     = var.z-cluster-host
  token    = var.z-cluster-token
  insecure = true
}

provider "kubernetes" {
  alias    = "x86-cluster"
  host     = var.x86-cluster-host
  token    = var.x86-cluster-token
  insecure = true
}

provider "kubernetes" {
  alias    = "power-cluster"
  host     = var.power-cluster-host
  token    = var.power-cluster-token
  insecure = true
}

provider "kubectl" {
  host     = var.dev-cluster-host
  token    = var.dev-cluster-token
  insecure = true
}
