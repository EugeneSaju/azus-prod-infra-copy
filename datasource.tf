data "aws_route53_zone" "get_data_hosted_zone_name" {

  name         = var.hosted_zone_name
  private_zone = false

}


