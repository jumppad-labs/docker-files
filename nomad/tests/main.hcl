variable "version" {
  default = "v1.9.3"
}

resource "network" "cloud" {
  subnet = "10.5.0.0/16"
}

resource "nomad_cluster" "dev" {
  client_nodes = 3

  image {
    name = "ghcr.io/jumppad-labs/nomad:${variable.version}"
  }

  network {
    id = resource.network.cloud.meta.id
  }
}

resource "nomad_job" "example_1" {
  cluster = resource.nomad_cluster.dev

  paths = ["./files/example.nomad"]

  health_check {
    timeout = "60s"
    jobs    = ["example_1"]
  }
}

resource "ingress" "fake_service_1" {
  port = 19090

  target {
    resource   = resource.nomad_cluster.dev
    named_port = "http"

    config = {
      job   = "example_1"
      group = "fake_service"
      task  = "fake_service"
    }
  }
}