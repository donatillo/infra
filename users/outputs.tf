output "access_key" {
    value = "${aws_iam_access_key.dynamo_key.id}"
}

output "secret_key" {
    value = "${aws_iam_access_key.dynamo_key.secret}"
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
