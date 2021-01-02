# Instance
data "aws_ami" "wordpress" {
  most_recent = true

  filter {
    name   = "name"
    values = ["laiello.com"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["385445628596"]
}

resource "aws_instance" "ec2" {
  ami                     = data.aws_ami.wordpress.id
  instance_type           = var.instance_size
  key_name                = var.key_name
  iam_instance_profile    = aws_iam_instance_profile.laiello_instance_profile.name
  disable_api_termination = true
  monitoring              = true

  network_interface {
    network_interface_id = aws_network_interface.eni.id
    device_index         = 0
  }

  tags = merge(local.tags, { "Name" : "laiello.com" })
}

# Instance Profile
resource "aws_iam_instance_profile" "laiello_instance_profile" {
  name = "laiello_wordpress_instance_profile"
  role = aws_iam_role.laiello_ec2_role.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  role       = aws_iam_role.laiello_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  role       = aws_iam_role.laiello_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# FIXME
# resource "aws_iam_role_policy_attachment" "ecs_client" {
#   role       = aws_iam_role.laiello_ec2_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerServiceforEC2Role"
# }

resource "aws_iam_role" "laiello_ec2_role" {
  name = "laiello_wordpress_ec2_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

  tags = local.tags
}

data "aws_ebs_volume" "ebs_volume" {
  most_recent = true

  filter {
    name   = "attachment.instance-id"
    values = [aws_instance.ec2.id]
  }

  tags = local.tags
}

# Elastic IP
resource "aws_network_interface" "eni" {
  subnet_id       = data.terraform_remote_state.arch.outputs.vpc_public_subnets[0]
  security_groups = [aws_security_group.wordpress.id]

  tags = local.tags
}

resource "aws_eip" "one" {
  vpc               = true
  network_interface = aws_network_interface.eni.id

  tags = local.tags
}

# Backups
resource "aws_backup_plan" "laiello_backup_plan" {
  name = "laiello-wordpress-backup-plan"

  rule {
    rule_name         = "laiello-wordpress-backup-rule"
    target_vault_name = "Default"
    schedule          = "cron(0 5 ? * 1 *)"
  }
}

resource "aws_iam_role" "backup_role" {
  name               = "laiello_wordpress_backup_role"
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

  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "backup_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup_role.name
}

resource "aws_backup_selection" "laiello_backup_selection" {
  name         = "laiello-wordpress-backup-selection"
  iam_role_arn = aws_iam_role.backup_role.arn
  plan_id      = aws_backup_plan.laiello_backup_plan.id

  resources = [
    data.aws_ebs_volume.ebs_volume.arn
  ]
}
