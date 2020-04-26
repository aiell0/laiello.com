# Instance
resource "aws_instance" "ec2" {
  ami                     = var.ami
  instance_type           = var.instance_size
  availability_zone       = var.az_map[var.subnet_id]
  key_name                = var.key_name
  disable_api_termination = true
  monitoring              = true

  network_interface {
      network_interface_id = aws_network_interface.eni.id
      device_index         = 0
  }
}

data "aws_ebs_volume" "ebs_volume" {
  most_recent = true

  filter {
    name   = "attachment.instance-id"
    values = [aws_instance.ec2.id]
  }
}

# Elastic IP
resource "aws_network_interface" "eni" {
  subnet_id                 = var.subnet_id
  security_groups           = [aws_security_group.wordpress_personal.id]
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.eni.id
}

# Backups
resource "aws_backup_plan" "laiello_backup_plan" {
  name = "laiello-backup-plan"

  rule {
    rule_name         = "laiello-backup-rule"
    target_vault_name = "Default"
    schedule          = "cron(0 5 ? * 1 *)"
  }
}

resource "aws_iam_role" "backup_role" {
  name               = "laiello_backup_role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": ["sts:AssumeRole"],
      "Effect": "allow",
      "Principal": {
        "Service": ["backup.amazonaws.com"]
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "backup_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}

resource "aws_backup_selection" "laiello_backup_selection" {
  name         = "laiello-backup-selection"
  iam_role_arn = aws_iam_role.backup_role.arn
  plan_id      = aws_backup_plan.laiello_backup_plan.id

  resources = [
    data.aws_ebs_volume.ebs_volume.arn
  ]
}