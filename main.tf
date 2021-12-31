module "web_server" {
    source = "./httpd"
    instance_type = "t2.micro"
}

output "public_dns" {
    value = module.web_server.public_dns
}

