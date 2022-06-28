terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      configuration_aliases = [
        kubernetes.cluster-context,
      ]
    }
  }
}

# Create dev project
resource "kubernetes_namespace" "dev-project" {
  provider = kubernetes.cluster-context
  metadata {
    name = "${var.project-name}-dev"
  }
}

data "local_file" "sa-token-x86-cluster" {
  filename = "sa-token-${var.x86-module-name}"
}

data "local_file" "sa-token-z-cluster" {
  filename = "sa-token-${var.z-module-name}"
}

data "local_file" "sa-token-power-cluster" {
  filename = "sa-token-${var.power-module-name}"
}

# Create secrets using tokens from workload clusters
resource "kubernetes_secret" "x86-cluster-token" {
  provider = kubernetes.cluster-context
  metadata {
    name      = "${var.x86-module-name}-secret"
    namespace = "${var.project-name}-dev"
  }
  data = {
    openshift-token = data.local_file.sa-token-x86-cluster.content
    openshift-url   = var.x86-cluster-host
  }
}

resource "kubernetes_secret" "z-cluster-token" {
  provider = kubernetes.cluster-context
  metadata {
    name      = "${var.z-module-name}-secret"
    namespace = "${var.project-name}-dev"
  }
  data = {
    openshift-token = data.local_file.sa-token-z-cluster.content
    openshift-url   = var.z-cluster-host
  }
}

resource "kubernetes_secret" "power-cluster-token" {
  provider = kubernetes.cluster-context
  metadata {
    name      = "${var.power-module-name}-secret"
    namespace = "${var.project-name}-dev"
  }
  data = {
    openshift-token = data.local_file.sa-token-power-cluster.content
    openshift-url   = var.power-cluster-host
  }
}

resource "kubernetes_secret" "docker-registry-access" {
  provider = kubernetes.cluster-context
  type     = "Opaque"
  metadata {
    name      = "docker-registry-access"
    namespace = kubernetes_namespace.dev-project.metadata[0].name
  }
  data = {
    "REGISTRY_PASSWORD" = var.registry-token
    "REGISTRY_USER"     = var.registry-user
  }
}

resource "null_resource" "oc-apply" {
  depends_on = [
    kubernetes_secret.docker-registry-access,
    kubernetes_namespace.dev-project
  ]
  provisioner "local-exec" {
    command = "BINPATH=\"bin\" && ./$BINPATH/oc login --token=${var.cluster-token} --server=${var.cluster-host} --insecure-skip-tls-verify && ./$BINPATH/oc apply -f ibm-garage-tekton-tasks/pipelines -n tools && ./$BINPATH/oc apply -f ibm-garage-tekton-tasks/tasks -n tools"
  }
}

resource "null_resource" "igc-sync" {
  depends_on = [
    kubernetes_namespace.dev-project,
    kubernetes_secret.docker-registry-access,
  ]
  provisioner "local-exec" {
    command = "BINPATH=\"bin\" && ./$BINPATH/oc login --token=${var.cluster-token} --server=${var.cluster-host} --insecure-skip-tls-verify && ./$BINPATH/igc sync ${kubernetes_namespace.dev-project.metadata[0].name} --tekton"
  }
}
