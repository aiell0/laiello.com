resource "aws_sns_topic" "laiello_infrastructure" {
  name              = "laiello-wordpress"
  kms_master_key_id = "alias/aws/sns"

  tags = local.tags
}
