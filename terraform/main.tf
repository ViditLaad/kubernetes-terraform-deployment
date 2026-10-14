
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.35"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment_v1" "python_app" {
  metadata {
    name = "python-cicd-demo"

    labels = {
      app = "python-cicd-demo"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "python-cicd-demo"
      }
    }

    template {
      metadata {
        labels = {
          app = "python-cicd-demo"
        }
      }

      spec {
        container {
          name  = "python-cicd-demo"
          image = "ghcr.io/viditlaad/python-cicd-demo:latest"

          port {
            container_port = 5000
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = 5000
            }

            initial_delay_seconds = 5
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = 5000
            }

            initial_delay_seconds = 10
            period_seconds        = 20
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "64Mi"
            }

            limits = {
              cpu    = "500m"
              memory = "128Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "python_app" {
  metadata {
    name = "python-cicd-demo-service"
  }

  spec {
    type = "ClusterIP"

    selector = {
      app = "python-cicd-demo"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 5000
      protocol    = "TCP"
    }
  }
}
