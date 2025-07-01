resource "aws_iam_user" "developer" {
  name = "developer"

  tags = {
    Name = "developer"
  }
  
}

resource "aws_iam_policy" "developer_eks" {
  name = "AmazonEKSDeveloperPolicy"
  
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "eks:DescribeCluster",
          "eks:ListClusters",
          "eks:ListNodegroups",
          "eks:DescribeNodegroup"
        ],
        "Resource": "*"
      }
    ]
  }

    POLICY
}

resource "aws_iam_user_policy_attachment""developer_eks" {
  user       = aws_iam_user.developer.name
  policy_arn = aws_iam_policy.developer_eks.arn


}

resource "aws_eks_access_entry" "developer" {
  cluster_name = var.cluster_name
  principal_arn = aws_iam_user.developer.arn
  kubernetes_groups = ["my-viewer"]

  depends_on = [data.aws_eks_cluster.wait_for_cluster]
  
}

data "aws_eks_cluster" "wait_for_cluster" {
  name = var.cluster_name
  depends_on = [var.eks_cluster]
}