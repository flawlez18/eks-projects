data "aws_iam_policy_document" "developer" {
  statement {
    sid    = "AllowDeveloper"
    effect = "Allow"
    actions = [
      "eks:DescribeNodegroup",
      "eks:DescribeCluster",
      "eks:ListNodegroups",
      "eks:ListCLusters",
      "eks:AccessKubernetesApi",
      "eks:GetParameter",
      "eks:ListUpdates",
      "eks:ListFargateProfiles"

    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "admin" {
  statement {
    sid       = "AllowAdmin"
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]

  }
  statement {
    sid    = "AllowPassRole"
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]

    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["eks:amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "manager_assume_role" {
  statement {
    sid    = "AllowManagerAssumeRole"
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/manager"]
    }
  }
}