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
            "Sid": "ListAndDescribe",
            "Effect": "Allow",
            "Action": [
                "dynamodb:List*",
                "dynamodb:DescribeReservedCapacity*",
                "dynamodb:DescribeLimits",
                "dynamodb:DescribeTimeToLive"
            ],
            "Resource": "*"
        },
        {
            "Sid": "SpecificTable",
            "Effect": "Allow",
            "Action": [
                "dynamodb:BatchGet*",
                "dynamodb:DescribeStream",
                "dynamodb:DescribeTable",
                "dynamodb:Get*",
                "dynamodb:Query",
                "dynamodb:Scan",
                "dynamodb:BatchWrite*",
                "dynamodb:CreateTable",
                "dynamodb:Delete*",
                "dynamodb:Update*",
                "dynamodb:PutItem"
            ],
            "Resource": "arn:aws:dynamodb:*:*:table/*"
        }
    ]
}
EOF
}

/*
resource "aws_iam_access_key" "dynamo_key" {
    user = "${aws_iam_user.dynamo.name}"
}
*/

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
