resource "aws_key_pair" "azus_prod_key" {

  key_name   = "${var.project_name}-${var.project_env}"
  public_key = file("azus-prod-key.pub")
  tags = {
    Name    = "${var.project_name}-${var.project_env}"
    project = var.project_name
    env     = var.project_env
  owner = var.project_owner }

}
