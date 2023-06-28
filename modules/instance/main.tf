data "aws_ami" "linux-ami" {
  most_recent = true

  filter {
    name   = "image-id"
    values = [var.image_name]
  }


  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}



resource "aws_key_pair" "ssh-key" {
  key_name   = "${var.keyname}-server-key"
  public_key = var.public_key
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.linux-ami.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [var.security_group_id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.ssh-key.key_name

  user_data = file("${var.script_file}")

  tags = {
    Name = "${var.server_name}-server"
  }
}

resource "aws_cloudwatch_dashboard" "nginx_dashboard" {
  dashboard_name = "nginx-dashboard"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "text",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 3,
      "properties": {
        "markdown": "# Instance Status\nStatus: [${aws_instance.web.state}](instance-id)"
      }
    }
  ]
}
EOF
}