resource "aws_resourcegroups_group" "resg-devl" {
    name = "init-aws-devl"
    description = "Devl resources build by init-aws."
    
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
    description = "Master resources build by init-aws."
    
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

resource "aws_resourcegroups_group" "resg2-devl" {
    name = "devl"
    description = "All devl resources."
    
    resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": ["AWS::AllSupported"],
  "TagFilters": [
    {
        "Key": "Environment",
        "Values": ["all", "devl"]
    }
  ]
}
JSON
  }
}

resource "aws_resourcegroups_group" "resg2-master" {
    name = "master"
    description = "All master resources."
    
    resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": ["AWS::AllSupported"],
  "TagFilters": [
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
