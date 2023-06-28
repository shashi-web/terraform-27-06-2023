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

resource "aws_cloudwatch_metric_alarm" "instance_status_alarm" {
  alarm_name          = "instance-status-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "SampleCount"
  threshold           = "1"
  alarm_description   = "Alarm for instance status check failure"
  alarm_actions       = ["arn:aws:sns:us-east-1:419716525079:demo:fde4395f-33cf-4d78-a4dc-4e683e36af8f"]
  dimensions = {
    InstanceId = aws_instance.web.id
  }
}

resource "aws_cloudwatch_dashboard" "nginx2_dashboard" {
  dashboard_name = "nginx2-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "text",
        x = 0,
        y = 0,
        width = 12,
        height = 3,
        properties = {
          markdown = "# Instance Status"
        }
      },
      {
        type = "alarm",
        x = 0,
        y = 3,
        width = 12,
        height = 3,
        properties = {
          alarms = [aws_cloudwatch_metric_alarm.instance_status_alarm.arn],
          title = "Instance Status Alarm",
          period = 300,
          stat = "SampleCount",
          region = "us-east-1"
        }
      },
      {
        "type": "metric",
        "x": 0,
        "y": 6,
        "width": 12,
        "height": 6,
        "properties": {
          "metrics": [
            [
              "AWS/EC2",
              "CPUUtilization",
              {
                "stat": "Average",
                "period": 300,
                "label": "CPU Utilization"
              }
            ]
          ],
          "view": "timeSeries",
          "stacked": false,
          "title": "CPU Utilization",
          "region": "us-east-1",
          "yAxis": {
            "left": {
              "min": 0,
              "max": 100,
              "showUnits": false
            }
          }
        }
      }
    ]
  })
}


