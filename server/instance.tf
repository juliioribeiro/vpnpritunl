resource "aws_instance" "pritunl_server" {
  ami                    = lookup(var.ami, terraform.workspace)
  instance_type          = lookup(var.instance_type, terraform.workspace)
  subnet_id              = data.terraform_remote_state.baseline.outputs.public_subnets[0]
  key_name               = aws_key_pair.pritunl_server.id
  security_groups        = [aws_security_group.pritunl_server.id]
  root_block_device {
    volume_size = 30 
    volume_type = "gp3"
  }
    connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = tls_private_key.key.private_key_pem
    host        = self.public_ip
  }

  provisioner "file" {
    content     = var.pritunl_script
    destination = "/tmp/pritunl.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/pritunl.sh",
      "cp /tmp/pritunl.sh /home/ec2-user",
      "sudo ./pritunl.sh",
      "sudo pritunl setup-key /etc/pritunl.conf"
    ]
  }
 

  tags = {
    Name = terraform.workspace
  }
}
resource "aws_eip" "eip" {
  vpc      = true
  instance = aws_instance.pritunl_server.id
  tags = {
    Name = "Pritunl-Server"
  }
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "pritunl_server" {
  key_name   = var.aws_key_name
  public_key = tls_private_key.key.public_key_openssh

  provisioner "local-exec" { # Generate "terraform-key-pair.pem" in current directory
    command = <<-EOT
      echo '${tls_private_key.key.private_key_pem}' > ./'${var.aws_key_name}'.pem
      chmod 400 ./'${var.aws_key_name}'.pem
    EOT
  }
}


resource "aws_iam_role" "pritunl_server" {
  name               = "pritunl-server"  
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "pritunl_server" {
  name        = "pritunl-server"
  description = ""

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeRouteTables",
        "ec2:CreateRoute",
        "ec2:ReplaceRoute",
        "ec2:DeleteRoute"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.pritunl_server.name
  policy_arn = aws_iam_policy.pritunl_server.arn
}
