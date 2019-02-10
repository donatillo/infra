resource "aws_route53_zone" "primary" {
    name             = "${var.domain}"
    tags {
        Creator = "init-aws"
        Description = "Main DNS record for domain ${var.domain}"
    }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
