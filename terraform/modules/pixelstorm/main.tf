locals {
  name = "pixelstorm-${var.env}"
}

resource "aws_iam_user" "user" {
  name = local.name
}

resource "aws_iam_access_key" "access_key" {
  user = aws_iam_user.user.name
}

// Group that awards members privileges
resource "aws_iam_group" "iam_group" {
  name = local.name
  path = "/pixelstorm/${var.env}/"
}

resource "aws_iam_policy" "iam_policy" {
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:RebootInstances",
          "ec2:ModifyInstanceAttribute"
        ],
        Resource = "*",
        Condition = {
          StringEquals = {
            "aws:ResourceTag/app" = "pixelstorm"
          }
        }
      },
      {
        Effect = "Allow",
        "Action" = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ],
        Resource = "arn:aws:s3:::denbeigh-terraform/pixelstorm/*"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:CreateVpc",
          "ec2:DeleteVpc",
          "ec2:ModifyVpcAttribute",
          "ec2:CreateInternetGateway",
          "ec2:DeleteInternetGateway",
          "ec2:AttachInternetGateway",
          "ec2:DetachInternetGateway",
          "ec2:CreateSubnet",
          "ec2:DeleteSubnet",
          "ec2:ModifySubnetAttribute",
          "ec2:CreateRouteTable",
          "ec2:DeleteRouteTable",
          "ec2:CreateRoute",
          "ec2:DeleteRoute",
          "ec2:AssociateRouteTable",
          "ec2:DisassociateRouteTable",
          "ec2:CreateSecurityGroup",
          "ec2:DeleteSecurityGroup",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupIngress"
        ],
        Resource = "*",
        Condition = {
          StringEquals = {
            "aws:ResourceTag/app" = "pixelstorm"
          }
        }
      }
    ]
  })

}

resource "aws_key_pair" "key_pair" {
  for_each = {
    for idx, region in var.regions :
    region.region => region
    if region.public_key != ""
  }

  key_name   = "pixelstorm-${var.env}-${each.value.region}"
  public_key = each.value.public_key

  lifecycle {
    ignore_changes = [
      # NOTE: Required to import a key
      public_key
    ]
  }
}
