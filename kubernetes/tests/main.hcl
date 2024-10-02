variable "version" {
  default = "v1.29.1"
}

resource "network" "cloud" {
  subnet = "10.5.0.0/16"
}

resource "k8s_cluster" "k3s" {
  image {
    name = "ghcr.io/jumppad-labs/kubernetes:${variable.version}"
  }

  network {
    id = resource.network.cloud.meta.id
  }
}

resource "helm" "vault" {
  cluster = resource.k8s_cluster.k3s

  repository {
    name = "hashicorp"
    url  = "https://helm.releases.hashicorp.com"
  }

  chart   = "hashicorp/vault"
  version = "v0.18.0"

  values = "./files/vault-values.yaml"

  health_check {
    timeout = "240s"
    pods    = ["app.kubernetes.io/name=vault"]
  }
}

resource "ingress" "vault_http" {
  port = 18200

  target {
    resource = resource.k8s_cluster.k3s
    port     = 8200

    config = {
      service   = "vault"
      namespace = "default"
    }
  }
}

output "KUBECONFIG" {
  value = resource.k8s_cluster.k3s.kube_config.path
}