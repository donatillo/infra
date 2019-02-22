data "aws_route53_zone" "primary" {
    name             = "${var.main_domain}"
    private_zone     = false
}

resource "aws_iam_user" "dynamo" {
    name = "dynamo"
    
    tags {
        Creator = "init-aws"
        Description = "User for using the dynamo tables."
        Environment = "all"
    }
}

resource "aws_iam_user_policy" "dynamo" {
    name = "dynamo_policy"
    user = "${aws_iam_user.dynamo.name}"

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "ds:CreateComputer",
                "ds:DescribeDirectories",
                "ec2:DescribeInstanceStatus",
                "logs:*",
                "ssm:*",
                "ec2messages:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:CreateServiceLinkedRole",
            "Resource": "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*",
            "Condition": {
                "StringLike": {
                    "iam:AWSServiceName": "ssm.amazonaws.com"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:DeleteServiceLinkedRole",
                "iam:GetServiceLinkedRoleDeletionStatus"
            ],
            "Resource": "arn:aws:iam::*:role/aws-service-role/ssm.amazonaws.com/AWSServiceRoleForAmazonSSM*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:GetChange"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect" : "Allow",
            "Action" : [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource" : [
                "arn:aws:route53:::hostedzone/${data.aws_route53_zone.primary.id}"
            ]
        },
        {
            "Effect" : "Allow",
            "Action" : [
                "ecs:UpdateService"
            ],
            "Resource" : ["*"]
        }
    ]
}
EOF
}

resource "aws_iam_access_key" "dynamo_key" {
    user = "${aws_iam_user.dynamo.name}"
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
