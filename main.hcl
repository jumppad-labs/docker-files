resource "network" "main" {
  subnet = "10.5.0.0/16"
}

resource "container" "postgres" {
  network {
    id = resource.network.main.meta.id
  }

  image {
    name = "postgres:13"
  }

  environment = {
    POSTGRES_PASSWORD = "temporal"
    POSTGRES_USER     = "temporal"
  }

  health_check {
    timeout = "30s"

    exec {
      script = "pg_isready"
    }
  }

  port {
    local = 5432
    host  = 5432
  }
}

resource "template" "temporal_config" {
  source      = <<-EOF
  limit.maxIDLength:
  - value: 255
    constraints: {}
  system.forceSearchAttributesCacheRefreshOnRead:
    - value: true # Dev setup only. Please don't turn this on in production.
      constraints: {}
  EOF
  destination = "${data("temporal")}/config.yaml"
}

resource "container" "temporal" {
  network {
    id = resource.network.main.meta.id
  }

  image {
    name = "temporalio/auto-setup:1.24.2"
  }

  environment = {
    DB             = "postgres12"
    ID             = resource.container.postgres.meta.id
    DB_PORT_3      = "${resource.container.postgres.port.0.local}"
    POSTGRES_SEEDS = "postgres"
    POSTGRES_USER  = "temporal"
    POSTGRES_PWD   = "temporal"
  }

  volume {
    source      = data("temporal")
    destination = "/etc/temporal/config/dynamicconfig"
  }

  port {
    local = 7233
    host  = 7233
  }
}