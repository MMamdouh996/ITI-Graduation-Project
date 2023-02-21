output "role_arn" {
  value = aws_iam_role.iam-role.arn
}
output "resource_attach" {
  value = aws_iam_role_policy_attachment.role_policy_attachment
}
output "role_name" {
  value = aws_iam_role.iam-role.name
}
