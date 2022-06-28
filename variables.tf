variable "project-name" {
  description = "Name of the projects that will be created on the OpenShift clusters, then names will be -dev, -test and -prod."
}

### Clusters hosts

variable "dev-cluster-host" {
  description = "Hostname of the dev cluster. This cluster will be used for the development stage, it should have the Cloud-Native Toolkit installed."
}

variable "x86-cluster-host" {
  description = "Hostname of the x86 cluster. This cluster will be used for running a remote pipeline aswell as deploying the application"
}

variable "z-cluster-host" {
  description = "Hostname of the z cluster. This cluster will be used for running a remote pipeline aswell as deploying the application"
}

variable "power-cluster-host" {
  description = "Hostname of the power cluster. This cluster will be used for running a remote pipeline aswell as deploying the application"
}

### Clusters tokens

variable "dev-cluster-token" {
  description = "Token of the dev cluster."
}

variable "x86-cluster-token" {
  description = "Token of the x86 cluster."
}

variable "z-cluster-token" {
  description = "Token of the z cluster."
}

variable "power-cluster-token" {
  description = "Token of the power cluster."
}

### Image registry access

variable "registry-user" {
  description = "Username for the image registry."
}

variable "registry-token" {
  description = "Token for the image registry."
}
