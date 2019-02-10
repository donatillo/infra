#
# VARIABLES
#

variable "access_key" {}
variable "secret_key" {}
variable "basename" {}
variable "region" {
    default = "us-east-1"
}

# 
# SETUP
#

provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region     = "${var.region}"
}

# 
# S3 bucket
# 

data "aws_caller_identity" "current" {}

data "template_file" "policy" {
	template 	= "${file("policy.json")}"
	vars {
		user    = "${data.aws_caller_identity.current.arn}"
        basename = "${var.basename}"
	}
}

resource "aws_s3_bucket" "backend" {
    bucket      = "${var.basename}-terraform"
	acl         = "private"
    policy      = "${data.template_file.policy.rendered}"
	versioning {
		enabled = true
	}
    tags {
        Creator = "init-aws-backend"
        Description = "Terraform backend file repository"
    }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
