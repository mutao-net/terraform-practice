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