terraform {
    backend "s3" {
        key    = "infra-resourcegroups.state"
        region = "us-east-1"
    }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
