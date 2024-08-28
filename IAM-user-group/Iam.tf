# group definition
resource "aws_iam_group" "administrator" {
    name = "administrator"
}
resource "aws_iam_policy_attachment" "administrator-attach" {
    name = "administrator-attach"
    groups = [aws_iam_group.administrator.name]
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
# user
resource "aws_iam_user" "admin1" {
    name = "admin1"
}
resource "aws_iam_user" "admin2" {
    name = "admin2"
}
resource "aws_iam_group_membership" "administrator-users" {
    name = "administrator-users"
    users = [
           aws_iam_user.admin1.name,
           aws_iam_user.admin2.name
    ]
    group = aws_iam_group.administrator.name
}

output "warning" {
    value = "WARNING: make sure you're not using the AdministratorAccess policy for other users/groups/roles. If this is the case, don't run terraform destroy, but manually unlink the created resources"
}