variable "access_key" {}
variable "secret_key" {}

provider "aws" {
    access_key      = "${var.access_key}"
    secret_key      = "${var.secret_key}"
    region          = "us-east-1"
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
