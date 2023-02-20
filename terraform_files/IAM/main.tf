resource "aws_iam_role" "iam-role" {
  name = var.iam_role_name

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "${var.using_service}.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  POLICY
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  for_each   = toset(var.policies_arns)
  policy_arn = each.value
  role       = aws_iam_role.iam-role.name
}
