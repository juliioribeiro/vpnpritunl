module "pritunl_server" {
  source         = "./server"
  aws_key_name   = "pritunl-key"
  pritunl_script = file("${path.module}/server/pritunl.sh")
}