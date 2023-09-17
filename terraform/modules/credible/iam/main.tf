locals {
  // Name for resources
  cat_name = var.allow_writes ? "read-write" : "read-only"
  name     = "credible-${var.env}-${local.cat_name}"

  // Map of device_name => device for iteration
  device_map = {
    for idx, d in var.devices :
    d.name => d
  }

  // Filtered map of device_name => device for iteration
  filtered_device_map = {
    for idx, d in var.devices :
    d.name => d
    if d.key_id != ""
  }

  // IAM statements
  list_bucket_statement = {
    Sid = "ListBucket",
    Action = [
      "s3:ListBucket"
    ],
    Effect   = "Allow",
    Resource = "arn:aws:s3:::${var.bucket_name}",
  }

  get_items_statement = {
    Sid = "GetItems",
    Action = [
      "s3:GetObject"
    ],
    Effect   = "Allow",
    Resource = "arn:aws:s3:::${var.bucket_name}",
  }

  read_write_statement = {
    Sid    = "ItemsReadWrite",
    Effect = "Allow",
    Action = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject"
    ],
    Resource = "arn:aws:s3:::${var.bucket_name}/*",
  }

  // IAM policies
  read_only_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      local.list_bucket_statement,
      local.get_items_statement,
    ]
  })

  read_write_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      local.list_bucket_statement,
      local.read_write_statement,
    ]
  })
}

// Group that awards members privileges
resource "aws_iam_group" "iam_group" {
  name = local.name
  path = "/credible/${var.env}/"
}

// Policy that defines necessry privileges
resource "aws_iam_policy" "iam_policy" {
  name        = local.name
  path        = "/credible/${var.env}/"
  description = "Terraform-managed access policy for Credible (${local.cat_name})"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = var.allow_writes ? local.read_write_policy : local.read_only_policy
}

// Attach the policy to the group
resource "aws_iam_group_policy_attachment" "policy_attachment" {
  group      = aws_iam_group.iam_group.name
  policy_arn = aws_iam_policy.iam_policy.arn
}

resource "aws_iam_user" "users" {
  for_each = local.device_map

  name = "credible-${var.env}-device-${each.value.name}"
}

// Add users to groups
resource "aws_iam_user_group_membership" "group_membership" {
  for_each = local.device_map

  user = resource.aws_iam_user.users[each.key].name

  groups = [
    aws_iam_group.iam_group.name,
  ]
}

// NOTE: We require users to imports these themselves
// Define access keys to bucket (so they can be revoked if necessary)
resource "aws_iam_access_key" "access_key" {
  for_each = local.filtered_device_map
  user     = aws_iam_user.users[each.value.name].name
}
