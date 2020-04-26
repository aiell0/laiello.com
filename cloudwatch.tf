resource "aws_cloudwatch_metric_alarm" "cpu_anomaly_detection" {
  alarm_name                = "laiello-com-cpu-detection"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = "3"
  threshold_metric_id       = "e1"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  alarm_actions             = [aws_sns_topic.laiello_infrastructure.arn]

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "CPUUtilization (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "CPUUtilization"
      namespace   = "AWS/EC2"
      period      = "60"
      stat        = "Average"
      unit        = "Count"

      dimensions = {
        InstanceId = aws_instance.ec2.id
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "network_in_anomaly_detection" {
  alarm_name                = "laiello-com-network-detection"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = "3"
  threshold_metric_id       = "e1"
  alarm_description         = "This metric monitors inbound network traffic"
  alarm_actions             = [aws_sns_topic.laiello_infrastructure.arn]

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "NetworkIn (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"
    metric {
      metric_name = "NetworkIn"
      namespace   = "AWS/EC2"
      period      = "60"
      stat        = "Average"
      unit        = "Count"

      dimensions = {
        InstanceId = aws_instance.ec2.id
      }
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_credit_alarm" {
  alarm_name                = "cpu_credit_alarm"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUCreditBalance"
  namespace                 = "AWS/EC2"
  period                    = "120"
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
  period                    = "120"
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
  period                    = "120"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = "This metric monitors system status check failures"
  alarm_actions             = [aws_sns_topic.laiello_infrastructure.arn]
  dimensions = {
    InstanceId = aws_instance.ec2.id
  }
}