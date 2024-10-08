data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}

resource "kubernetes_namespace" "hello_world" {
  metadata {
    name = "hello-world"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace  = kubernetes_namespace.hello_world.metadata[0].name
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"

  set {
    name  = "controller.publishService.enabled"
    value = "true"
  }
}

resource "helm_release" "django_pizza" {
  name      = "django-pizza"
  namespace = kubernetes_namespace.hello_world.metadata[0].name
  chart     = "/home/ubuntu/t2/eks-cluster/django-pizza"  # Ajusta esta ruta si tu chart está en una ubicación diferente

  set {
    name  = "image.repository"
    value = "carloscloud/django-pizza"
  }

  set {
    name  = "image.tag"
    value = "v3"
  }

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "ingress.enabled"
    value = "true"
  }

  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "nginx"
  }

  set {
    name  = "ingress.hosts[0].host"
    value = "a7ee7531ffbd546c585399a0f093da42-586082723.us-west-2.elb.amazonaws.com"
  }

  set {
    name  = "ingress.hosts[0].paths[0].path"
    value = "/"
  }

  set {
    name  = "ingress.hosts[0].paths[0].pathType"
    value = "Prefix"
  }
}