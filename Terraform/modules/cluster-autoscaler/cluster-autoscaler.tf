resource "aws_iam_role" "cluster_autoscaler" {
  name = "${var.cluster_name}-cluster-autoscaler"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          "StringEquals" = {
            "pods.eks.amazonaws.com/sa-name"      = "cluster-autoscaler",
            "pods.eks.amazonaws.com/sa-namespace" = "kube-system"
          }
        }
      }
    ]
  })
}
resource "aws_iam_policy" "cluster_autoscaler_policy" {
    name = "${var.cluster_name}-cluster-autoscaler-policy"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "autoscaling:DescribeAutoScalingGroups",
                    "autoscaling:UpdateAutoScalingGroup",
                    "ec2:DescribeLaunchTemplateVersions",
                    "ec2:DescribeInstanceTypes",
                    "ec2:DescribeInstances",
                    "ec2:DescribeTags",
                    "ec2:CreateTags",
                    "ec2:DeleteTags"
                ]
                Effect = "Allow"
                Resource = "*"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler_attachment" {
    role       = aws_iam_role.cluster_autoscaler.name
    policy_arn = aws_iam_policy.cluster_autoscaler_policy.arn
  
}

resource "aws_eks_pod_identity_association" "cluster_autoscaler_association" {
    cluster_name = var.cluster_name
    namespace = "kube-system"
    service_account = "cluster-autoscaler"
    role_arn = aws_iam_role.cluster_autoscaler.arn
  
}

resource "helm_release" "cluster_autoscaler" {
    name       = "cluster-autoscaler"
    repository = "https://kubernetes.github.io/autoscaler"
    chart      = "cluster-autoscaler"
    version    = "9.37.0"
    namespace  = "kube-system"

    set {
        name  = "autoDiscovery.clusterName"
        value = var.cluster_name
    }

    set {
        name  = "awsRegion"
        value = var.region
    }

    set {
        name  = "rbac.serviceAccount.name"
        value = "cluster-autoscaler"
    }

    depends_on = [
        aws_iam_role_policy_attachment.cluster_autoscaler_attachment,
        aws_eks_pod_identity_association.cluster_autoscaler_association
        
    ]
  
}