provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}


resource "helm_release" "vault" {
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  namespace  = "default"
  

  values = [
    "${file("override-values.yaml")}"
  ]

}


resource "helm_release" "csi_drivers" {
  name       = "csi-secrets-store"

  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "default"


  set {
      name = "syncSecret.enabled"
      value = "true"
  }
  set {
      name = "enableSecretRotation"
      value = "true"
  }

}




