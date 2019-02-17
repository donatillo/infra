resource "aws_kms_key" "key" {
    description = "Main KMS for accessing SSM"
}

resource "aws_kms_alias" "a" {
    name          = "alias/ssm_store"
    target_key_id = "${aws_kms_key.key.key_id}"
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
