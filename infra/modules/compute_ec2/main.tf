resource "aws_iam_role" "instance" {
  name = "${var.name}-${var.environment}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "s3_read" {
  name = "${var.name}-${var.environment}-s3-server-rb"
  role = aws_iam_role.instance.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "arn:aws:s3:::${var.app_s3_bucket}/server.rb"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-${var.environment}-instance-profile"
  role = aws_iam_role.instance.name
}

resource "aws_security_group" "instance" {
  name        = "${var.name}-${var.environment}-sg"
  description = "Allow inbound TCP 8080 from approved CIDRs only"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "this" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  iam_instance_profile   = aws_iam_instance_profile.this.name
  vpc_security_group_ids = [aws_security_group.instance.id]
  user_data              = <<-EOF
        #!/bin/bash
        dnf install -y ruby
        export BUCKET=${var.app_s3_bucket}
        aws s3 cp s3://$BUCKET/server.rb /opt/server.rb
        COMPUTE_TYPE=ec2 nohup ruby /opt/server.rb &
    EOF

  tags = {
    Name        = "${var.name}-${var.environment}-ec2-instance"
    Environment = var.environment
  }
}

