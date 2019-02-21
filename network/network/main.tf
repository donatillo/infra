# VPC

variable "env"      {}
variable "basename" {}

resource "aws_vpc" "main" {
    cidr_block  = "10.0.0.0/16"
    
    tags {
        Name        = "${var.basename}-vpc-${var.env}"
        Creator     = "infra"
        Description = "Main VPC"
        Environment = "${var.env}"
    }
}

# internet gateway

resource "aws_internet_gateway" "ig_public_subnet" {
    vpc_id      = "${aws_vpc.main.id}"

    tags {
        Name        = "${var.basename}-ig-${var.env}"
        Creator     = "infra"
        Description = "Internet gateway for public subnets"
        Environment = "${var.env}"
    }
}

# subnets (public)

module "subnet-az-a" {
    source              = "./pubsubnet"
    env                 = "${var.env}"
    basename            = "${var.basename}"
    availability_zone   = "a"
    cidr_block          = "10.0.2.0/24"
    vpc_id              = "${aws_vpc.main.id}"
    internet_gateway_id = "${aws_internet_gateway.ig_public_subnet.id}"
}

module "subnet-az-b" {
    source              = "./pubsubnet"
    env                 = "${var.env}"
    basename            = "${var.basename}"
    availability_zone   = "b"
    cidr_block          = "10.0.3.0/24"
    vpc_id              = "${aws_vpc.main.id}"
    internet_gateway_id = "${aws_internet_gateway.ig_public_subnet.id}"
}

# subnet (private)


resource "aws_subnet" "private-a" {
    vpc_id      = "${aws_vpc.main.id}"
    cidr_block  = "10.0.0.0/24"

    tags {
        Name        = "${var.basename}-subnet-private-${var.env}-a"
        Creator     = "infra"
        Description = "Main private subnet - zone a"
        Environment = "${var.env}"
    }
}


resource "aws_subnet" "private-b" {
    vpc_id      = "${aws_vpc.main.id}"
    cidr_block  = "10.0.1.0/24"

    tags {
        Name        = "${var.basename}-subnet-private-${var.env}-b"
        Creator     = "infra"
        Description = "Main private subnet - zone b"
        Environment = "${var.env}"
    }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
