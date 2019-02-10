# VPC

variable "env" {}
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

# subnet (public)

resource "aws_subnet" "public" {
    vpc_id      = "${aws_vpc.main.id}"
    cidr_block  = "10.0.1.0/24"

    tags {
        Name        = "${var.basename}-subnet-public-${var.env}"
        Creator     = "init-aws"
        Description = "Main public subnet"
        Environment = "${var.env}"
    }
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

# internet gateway

resource "aws_internet_gateway" "ig_public_subnet" {
    vpc_id      = "${aws_vpc.main.id}"

    tags {
        Name        = "${var.basename}-ig-${var.env}"
        Creator     = "init-aws"
        Description = "Internet gateway for public subnet"
        Environment = "${var.env}"
    }
}

# route table (associated to the internet gateway and public subnet)

resource "aws_route_table" "rt" {
    vpc_id      = "${aws_vpc.main.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.ig_public_subnet.id}"
    }

    tags {
        Name        = "${var.basename}-rt-${var.env}"
        Creator     = "init-aws"
        Description = "Route table for internet gateway"
        Environment = "${var.env}"
    }
}

resource "aws_route_table_association" "x" {
    subnet_id       = "${aws_subnet.public.id}"
    route_table_id  = "${aws_route_table.rt.id}"
}


# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
