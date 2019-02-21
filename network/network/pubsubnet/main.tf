variable "env"                 {}
variable "basename"            {}
variable "availability_zone"   {}
variable "cidr_block"          {}
variable "vpc_id"              {}
variable "internet_gateway_id" {}

# subnet (public)

resource "aws_subnet" "public" {
    vpc_id      = "${var.vpc_id}"
    cidr_block  = "${var.cidr_block}"
    availability_zone = "us-east-1${var.availability_zone}"

    tags {
        Name        = "${var.basename}-subnet-public-${var.env}-${var.availability_zone}"
        Creator     = "init-aws"
        Description = "Main public subnet - zone ${var.availability_zone}"
        Environment = "${var.env}"
    }
}

# route table (associated to the internet gateway and public subnet)

resource "aws_route_table" "rt" {
    vpc_id      = "${var.vpc_id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${var.internet_gateway_id}"
    }

    tags {
        Name        = "${var.basename}-rt-${var.env}-${var.availability_zone}"
        Creator     = "init-aws"
        Description = "Route table for internet gateway - zone ${var.availability_zone}"
        Environment = "${var.env}"
    }
}

resource "aws_route_table_association" "x" {
    subnet_id       = "${aws_subnet.public.id}"
    route_table_id  = "${aws_route_table.rt.id}"
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
