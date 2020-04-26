resource "aws_sns_topic" "laiello_infrastructure" {
  name              = "laiello-infrastructure"
  kms_master_key_id = "alias/aws/sns"
}