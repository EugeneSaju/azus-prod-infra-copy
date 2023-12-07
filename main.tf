resource "aws_key_pair" "azus_prod_key" {

  key_name   = "${var.project_name}-${var.project_env}"
  public_key = file("azus-prod-key.pub")
  tags = {
    Name    = "${var.project_name}-${var.project_env}"
    project = var.project_name
    env     = var.project_env
  owner = var.project_owner }

}

resource "aws_security_group" "http_access" {

  name        = "${var.project_name}-${var.project_env}-http_access"
  description = "${var.project_name}-${var.project_env}-http_access"


  ingress {

    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  ingress {

    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  egress {

    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  tags = {
    Name    = "${var.project_name}-${var.project_env}-http_access"
    project = var.project_name
    env     = var.project_env
    owner   = var.project_owner
  }
}

resource "aws_security_group" "remote_access" {

  name        = "${var.project_name}-${var.project_env}-remote_access"
  description = "${var.project_name}-${var.project_env}-remote_access"


  ingress {

    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  egress {

    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  tags = {
    Name    = "${var.project_name}-${var.project_env}-remote_access"
    project = var.project_name
    env     = var.project_env
    owner   = var.project_owner
  }
}

resource "aws_instance" "frontend" {

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.azus_prod_key.key_name
  user_data              = file("setup.sh")
  vpc_security_group_ids = [aws_security_group.http_access.id, aws_security_group.remote_access.id]
  tags = {
    Name    = "${var.project_name}-${var.project_env}-frontend"
    project = var.project_name
    env     = var.project_env
    owner   = var.project_owner
  }

  lifecycle {
    create_before_destroy = true
  }

}

