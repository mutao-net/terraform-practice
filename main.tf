/**
module "web_server" {
  source        = "./httpd"
  instance_type = "t2.micro"
}

module "s3_storage" {
  source = "./s3"
}

output "public_dns" {
  value = module.web_server.public_dns
}
*/
data "aws_iam_policy_document" "allow_describe_regions" {
  statement {
    effect    = "Allow"
    actions   = ["ec2:DescribeRegions"]
    resources = ["*"]
  }
}

module "describe_regions_for_ec2" {
  source     = "./role"
  name       = "describe_regions_for_ec2"
  identifier = "ec2.amazonaws.com"
  policy     = data.aws_iam_policy_document.allow_describe_regions.json
}

