resource "aws_sns_topic" "laiello_infrastructure" {
  name = "laiello-wordpress"

  tags = local.tags
}
