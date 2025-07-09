data "aws_iam_policy_document" "aws_lbc" {
    statement {
      effect = "Allow"

      principals {
        type        = "Service"
        identifiers = ["pods.eks.amazonaws.com"]
      }
        actions = [
            "sts:AssumeRole",
            "sts:TagSession"
        ]
    }
  
}
resource "aws_iam_role" "aws_lbc" {
    name = "${aws_eks_cluster.eks.name}-aws-lbc"
    assume_role_policy = data.aws_iam_policy_document.aws_lbc.json
  
}

resource "aws_iam_policy" "aws_lbc" {
    policy = file("${path.module}/iam/AWSLoadBalancerControllerPolicy.json")
    name = "AWSLoadBalancerController"  
}

resource "aws_iam_role_policy_attachment" "aws_lbc" {
    policy_arn = aws_iam_policy.aws_lbc.arn
    role       = aws_iam_role.aws_lbc.name
}

resource "aws_eks_pod_identity_association" "aws_lbc" {
    cluster_name    = var.cluster_name
    namespace       = "kube-system"
    service_account = "aws-load-balancer-controller"
    role_arn        = aws_iam_role.aws_lbc.arn
}

resource "helm_release" "aws_lbc" {
    name       = "aws-load-balancer-controller"
    repository = "https://aws.github.io/eks-charts"
    chart      = "aws-load-balancer-controller"
    version    = "1.7.2"

    namespace  = "kube-system"

    set {
        name  = "clusterName"
        value = var.cluster_name
    }

    set {
        name  = "serviceAccount.name"
        value = "aws-load-balancer-controller"
    }
    set {
        name  = "region"
        value = var.region
    } 

    depends_on = [aws_eks_pod_identity_association.aws_lbc]
  
}