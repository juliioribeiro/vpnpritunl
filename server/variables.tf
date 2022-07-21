variable "region" {
  default = "us-east-1"
}

variable "ami" {
  type = map(any)
  default = {
    "system"     = "ami-047627086234fbbe7"
    "nonprod"    = "ami-047627086234fbbe7"
    "data"       = "ami-047627086234fbbe7"
    "production" = "ami-047627086234fbbe7"
  }
}

variable "instance_type" {
  type = map(any)
  default = {
    "system"     = "t3.medium"
    "nonprod"    = "t3.small"
    "data"       = "t3.small"
    "production" = "t3.small"
  }
}

variable "aws_key_name" {
  type = string
}

variable "pritunl_script" { 
  type = string 
}
