
provider "vault" {
    address = "http://52.249.58.138:8200" #or http://vault.default:8200   
    token = "root"
}




# ++++++++++++++++++++++++++++
# kubernetes auth stuffs
# ++++++++++++++++++++++++++++

# athentication type is set to kubernetes 
resource "vault_auth_backend" "vault_auth" {
  type = "kubernetes"
}

# creating a new role for the vault_sa
resource "vault_kubernetes_auth_backend_config" "mainly" {
  kubernetes_host        = var.kubernetes_host
  kubernetes_ca_cert     = data.kubernetes_secret.vault_secret.data["ca.crt"]
  token_reviewer_jwt     = data.kubernetes_secret.vault_secret.data.token
  disable_iss_validation = "true"
}


# calling the secret token within the secret 
data "kubernetes_secret" "vault_secret" {
  metadata {
    name      = "${data.kubernetes_service_account.vault_sa.default_secret_name}"
    namespace = var.vault_sa_namespace #why not "${data.kubernetes_service_account.vault_sa.name}"
  }
}


# terraform resource refering to the vault_sa service account that was already created 
data "kubernetes_service_account" "vault_sa" {
  metadata {
    name      = var.vault_sa
    namespace = var.vault_sa_namespace
  }
}







# ++++++++++++++++++++++++++++++++++++++++++++
# authenticating developer service account
# ++++++++++++++++++++++++++++++++++++++++++++

# creating a policy resource
resource "vault_policy" "app_policy" {
  name   = "internal-app"
  policy = <<EOT
path "secret/*" {
  capabilities = ["read"]
}
EOT
}


# Enable database auth method
resource "vault_kubernetes_auth_backend_role" "example" {
  role_name                        = "database"
  bound_service_account_names      = [var.developers_sa]
  bound_service_account_namespaces = [var.developers_sa_namespace]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.app_policy.name]
}





#########################################################################

#  kubernetes varriables
variable "vault_sa" {
  description = "Service account name"
  type        = string
  default     = "vault"
}

variable "vault_sa_namespace" {
  description = "Service account namespace"
  type        = string
  default     = "default"
}

variable "kubernetes_host" {
  description = "Host must be a host string, a host:port pair, or a URL to the base of the Kubernetes API server"
  type        = string
  default     = "https://teststuffs-dns-cd70fa1c.hcp.southcentralus.azmk8s.io:443"
}



# developers service account variables

variable "developers_sa" {
  description = "Service account name for deployment"
  type        = string
  default     = "assign-chart-sa"
}

variable "developers_sa_namespace" {
  description = "deployment Service account namespace"
  type        = string
  default     = "default"
}

