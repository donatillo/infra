module "network-devl" {
    source   = "./network"
    env      = "devl"
    basename = "${var.basename}"
}

module "network-prod" {
    source   = "./network"
    env      = "master"
    basename = "${var.basename}"
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
