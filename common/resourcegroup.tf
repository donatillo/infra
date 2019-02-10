resource "aws_resourcegroups_group" "resg-devl" {
    name = "init-aws-devl"
    
    resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": ["AWS::AllSupported"],
  "TagFilters": [
    {
        "Key": "Creator",
        "Values": ["init-aws"]
    },
    {
        "Key": "Environment",
        "Values": ["all", "devl"]
    }
  ]
}
JSON
  }
}

resource "aws_resourcegroups_group" "resg-master" {
    name = "init-aws-master"
    
    resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": ["AWS::AllSupported"],
  "TagFilters": [
    {
      "Key": "Creator",
      "Values": ["init-aws"]
    },
    {
        "Key": "Environment",
        "Values": ["all", "master"]
    }

  ]
}
JSON
  }
}

# vim:ts=4:sw=4:sts=4:expandtab:syntax=conf
