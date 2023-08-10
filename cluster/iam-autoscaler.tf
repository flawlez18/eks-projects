data "aws_iam_policy_document" "eks_cluster_autoscaler_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:cluster-autoscaler"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }

  }
}

resource "aws_iam_role" "eks_cluster_autoscaler" {
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_autoscaler_role_policy.json
  name               = "eks-cluster-autoscaler"

}

resource "aws_iam_policy" "eks_cluster_autoscaler" {
  name = "eks-cluster-autoscaler"

  #  policy = jsonencode({
  #   statement = [{
  #     Action = [
  # "autoscaling:DescribeAutoscalingGroups",
  # "autoscaling:DescribeAutoscalingInstances",
  # "autoscaling:DescribeLaunchConfigurations",
  # "autoscaling:DescribeTags",
  # "autoscaling:SetDescribedCapacity",
  # "autoscaling:TerminateInstanceInAutoscalingGroup",
  # "ec2:DescribeLaunchTemplateVersions",
  # "ec2:DescribeInstanceTypes"
  #     ]
  #     Effect = "Allow"
  #     Resource = "*"
  #   }]
  #   Version = "2012-10-17"
  #  }) 

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
      "autoscaling:DescribeAutoscalingGroups",
      "autoscaling:DescribeAutoscalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDescribedCapacity",
      "autoscaling:TerminateInstanceInAutoscalingGroup",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:DescribeInstanceTypes"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "eks_cluster_autoscaler_attach" {
  role       = aws_iam_policy.eks_cluster_autoscaler.name
  policy_arn = aws_iam_policy.eks_cluster_autoscaler.arn
}

output "eks_cluster_autoscaler_arn" {
  value = aws_iam_role.eks_cluster_autoscaler.arn

}