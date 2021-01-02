data "aws_route53_zone" "primary" {
  name = "laiello.com"
}

resource "aws_route53_record" "map_eip" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = data.aws_route53_zone.primary.name
  type    = "A"
  ttl     = "300"
  records = [aws_eip.one.public_ip]
}
