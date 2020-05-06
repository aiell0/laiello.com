resource "aws_cloudwatch_metric_alarm" "network_inbound_alarm" {
  alarm_name                = "network_inbound_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "NetworkIn"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "100000000"
  alarm_description         = "This metric monitors inbound network traffic"
  alarm_actions             = [aws_sns_topic.laiello_infrastructure.arn]
  dimensions = {
    InstanceId = aws_instance.ec2.id
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  alarm_name                = "cpu_utilization_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "60"
  alarm_description         = "This metric monitors inbound network traffic"
  alarm_actions             = [aws_sns_topic.laiello_infrastructure.arn]
  dimensions = {
    InstanceId = aws_instance.ec2.id
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_credit_alarm" {
  alarm_name                = "cpu_credit_alarm"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "CPUCreditBalance"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "50"
  alarm_description         = "This metric monitors ec2 credit balance"
  alarm_actions             = [aws_sns_topic.laiello_infrastructure.arn]
  dimensions = {
    InstanceId = aws_instance.ec2.id
  }
}

resource "aws_cloudwatch_metric_alarm" "instance_status_check_alarm" {
  alarm_name                = "instance_status_check_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed_Instance"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "This metric monitors instance status check failures"
  alarm_actions             = [aws_sns_topic.laiello_infrastructure.arn]
  dimensions = {
    InstanceId = aws_instance.ec2.id
  }
}

resource "aws_cloudwatch_metric_alarm" "system_status_check_alarm" {
  alarm_name                = "system_status_check_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "StatusCheckFailed_System"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "This metric monitors system status check failures"
  alarm_actions             = [aws_sns_topic.laiello_infrastructure.arn]
  dimensions = {
    InstanceId = aws_instance.ec2.id
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_usage_alarm" {
  alarm_name                = "disk_usage_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "disk_used_percent"
  namespace                 = "CWAgent"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "60"
  alarm_description         = "This metric monitors disk space usage"
  alarm_actions             = [aws_sns_topic.laiello_infrastructure.arn]
  dimensions = {
    InstanceId = aws_instance.ec2.id
  }
}

resource "aws_cloudwatch_metric_alarm" "memory_usage_alarm" {
  alarm_name                = "memory_usage_alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "3"
  metric_name               = "mem_used_percent"
  namespace                 = "CWAgent"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "This metric monitors RAM usage"
  alarm_actions             = [aws_sns_topic.laiello_infrastructure.arn]
  dimensions = {
    InstanceId = aws_instance.ec2.id
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name                      = "laiello.com"
  retention_in_days         = 7
}

resource "aws_cloudwatch_log_stream" "apache_error_log" {
  name           = "apache_error_log"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}

resource "aws_cloudwatch_log_stream" "apache_access_log" {
  name           = "apache_access_log"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}

resource "aws_cloudwatch_log_stream" "apache_ssl_access_log" {
  name           = "apache_ssl_access_log"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}

resource "aws_cloudwatch_log_stream" "apache_ssl_error_log" {
  name           = "apache_ssl_error_log"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}

resource "aws_cloudwatch_log_stream" "apache_ssl_request_log" {
  name           = "apache_ssl_request_log"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}