terraform {
    backend "s3" {
        bucket = "${var.basename}-terraform"
        key    = "init-aws.state"
        region = "us-east-1"
    }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
