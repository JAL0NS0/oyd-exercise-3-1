data "aws_iam_policy_document" "ec2_assume_role" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "name" {
    name               = "${var.name}-${var.environment}-role"
    assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy" "name" {
    name = "${var.name}-${var.environment}-s3-server-rb"
    role = aws_iam_role.name.id

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

resource "aws_iam_instance_profile" "name" {
    name = "${var.name}-${var.environment}-instance-profile"
    role = aws_iam_role.name.name
}

resource "aws_security_group" "name" {
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

resource "aws_instance" "name" {
    ami                    = var.ami_id
    instance_type          = var.instance_type
    iam_instance_profile    = aws_iam_instance_profile.name.name
    vpc_security_group_ids  = [aws_security_group.name.id]
    user_data = <<-EOF
        #!/bin/bash
        set -e
        yum install -y ruby awscli
        aws s3 cp s3://${var.app_s3_bucket}/server.rb /home/ec2-user/server.rb
        chown ec2-user:ec2-user /home/ec2-user/server.rb
        sudo -u ec2-user bash -lc 'cd /home/ec2-user && COMPUTE_TYPE=ec2 ruby server.rb'
    EOF
}

