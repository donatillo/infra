data "aws_route53_zone" "primary" {
    name             = "${var.main_domain}"
    private_zone     = false
}

resource "aws_acm_certificate" "cert" {
    domain_name         = "*.${var.domain}"
    validation_method   = "DNS"

    lifecycle {
        create_before_destroy = true
    }

    tags {
        Creator     = "init-aws"
        Description = "Star certificate for domain ${var.domain}"
        Environment = "all"
    }
}

resource "aws_route53_record" "cert_validation" {
    name    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_name}"
    type    = "${aws_acm_certificate.cert.domain_validation_options.0.resource_record_type}"
    zone_id = "${data.aws_route53_zone.primary.id}"
    records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
    ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
    certificate_arn         = "${aws_acm_certificate.cert.arn}"
    validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
