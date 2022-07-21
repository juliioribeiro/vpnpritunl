data "terraform_remote_state" "baseline" {
  backend   = "s3"
  workspace = ""
  config = {
    bucket = ""
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}