resource "aws_cloudwatch_metric_alarm" "cpu_anomaly_detection" {
  alarm_name                = "laiello-com-cpu-detection"
  comparison_operator       = "GreaterThanUpperThreshold"
  evaluation_periods        = "5"
  threshold_metric_id       = "e1"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []

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
  evaluation_periods        = "5"
  threshold_metric_id       = "e1"
  alarm_description         = "This metric monitors inbound network traffic"
  insufficient_data_actions = []

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
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "50"
  alarm_description         = "This metric monitors ec2 credit balance"
  insufficient_data_actions = []
}