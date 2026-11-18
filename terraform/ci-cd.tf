
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}


data "aws_iam_policy_document" "github_trust" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:ishygit-sys/ECS-deploying-Faved:*",
        "repo:ishygit-sys@336461664/ECS-deploying-Faved@1442917443:*"
      ]
    }
  }
}

resource "aws_iam_role" "github_deploy" {
  name               = "github-actions-deploy"
  assume_role_policy = data.aws_iam_policy_document.github_trust.json
}


resource "aws_iam_role_policy_attachment" "github_deploy_ecs" {
  role       = aws_iam_role.github_deploy.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "github_deploy_ecr" {
  role       = aws_iam_role.github_deploy.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}




# give permission to read the Terraform state file in the S3 bucket

data "aws_iam_policy_document" "terraform_state" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
    ]
    resources = [
      "arn:aws:s3:::ecs-project-asdgasd",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]
    resources = [
      "arn:aws:s3:::ecs-project-asdgasd/ecs-clickops/terraform.tfstate",
      "arn:aws:s3:::ecs-project-asdgasd/ecs-clickops/terraform.tfstate.tflock",
    ]
  }
}

resource "aws_iam_policy" "terraform_state" {
  name   = "terraform-state-access"
  policy = data.aws_iam_policy_document.terraform_state.json
}

resource "aws_iam_role_policy_attachment" "terraform_state" {
  role       = aws_iam_role.github_deploy.name
  policy_arn = aws_iam_policy.terraform_state.arn
}



# Read access for IAM (needed for OIDC provider and policy refresh)
resource "aws_iam_role_policy_attachment" "github_iam_read" {
  role       = aws_iam_role.github_deploy.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

# Read access for ACM
resource "aws_iam_role_policy_attachment" "github_acm_read" {
  role       = aws_iam_role.github_deploy.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCertificateManagerReadOnly"
}

# Read access for ELB (ALB/Target Group describe operations)
resource "aws_iam_role_policy_attachment" "github_elb_read" {
  role       = aws_iam_role.github_deploy.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingReadOnly"
}


data "aws_iam_policy_document" "logs_tags" {
  statement {
    effect    = "Allow"
    actions   = ["logs:ListTagsForResource"]
    resources = ["*"] # or scope to your log group ARN
  }
}

resource "aws_iam_policy" "logs_tags" {
  name   = "logs-list-tags"
  policy = data.aws_iam_policy_document.logs_tags.json
}

resource "aws_iam_role_policy_attachment" "logs_tags" {
  role       = aws_iam_role.github_deploy.name
  policy_arn = aws_iam_policy.logs_tags.arn
}
