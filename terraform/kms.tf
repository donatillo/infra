# find users
data "aws_caller_identity" "ci" {}

data "aws_iam_user" "console" {
    user_name = "${var.console_user}"
}

# parse policy file
data "template_file" "policy" {
    template    = "${file("keypolicy.json")}"
    vars {
        root    = "${data.aws_caller_identity.ci.arn}"
        ci      = "${data.aws_caller_identity.ci.arn}"
		dynamo  = "${aws_iam_user.dynamo.arn}"
        console = "${data.aws_iam_user.console.arn}"
    }
}

# create key
resource "aws_kms_key" "key" {
    description = "Main KMS for accessing SSM"
    policy      = "${data.template_file.policy.rendered}"
}

resource "aws_kms_alias" "a" {
    name          = "alias/ssm_store"
    target_key_id = "${aws_kms_key.key.key_id}"
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
