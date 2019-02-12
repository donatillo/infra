# VPC

variable "env"      {}
variable "basename" {}

resource "aws_vpc" "main" {
    cidr_block  = "10.0.0.0/16"
    
    tags {
        Name        = "${var.basename}-vpc-${var.env}"
        Creator     = "init-aws"
        Description = "Main VPC"
        Environment = "${var.env}"
    }
}

# subnets (public)

module "subnet-az-a" {
    source            = "./pubsubnet"
    env               = "${var.env}"
    basename          = "${var.basename}"
    availability_zone = "a"
    cidr_block        = "10.0.1.0/24"
    vpc_id            = "${aws_vpc.main.id}"
}

# subnet (private)

resource "aws_subnet" "private" {
    vpc_id      = "${aws_vpc.main.id}"
    cidr_block  = "10.0.0.0/24"

    tags {
        Name        = "${var.basename}-subnet-private-${var.env}"
        Creator     = "init-aws"
        Description = "Main private subnet"
        Environment = "${var.env}"
    }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
