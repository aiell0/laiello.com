resource "aws_ssm_parameter" "cloudwatch_agent_config" {
  name        = "AmazonCloudWatch-linux"
  description = "Cloudwatch agent configuration for linux servers"
  type        = "String"
  overwrite   = true
  value       = <<EOF
{
	"agent": {
		"metrics_collection_interval": 60,
		"run_as_user": "root"
	},
	"logs": {
		"logs_collected": {
			"files": {
				"collect_list": [
					{
						"file_path": "/var/log/httpd/access_log",
						"log_group_name": "${aws_cloudwatch_log_group.log_group.name}",
						"log_stream_name": "${aws_cloudwatch_log_stream.apache_access_log.name}"
					},
					{
						"file_path": "/var/log/httpd/error_log",
						"log_group_name": "${aws_cloudwatch_log_group.log_group.name}",
						"log_stream_name": "${aws_cloudwatch_log_stream.apache_error_log.name}"
					},
					{
						"file_path": "/var/log/httpd/ssl_access_log",
						"log_group_name": "${aws_cloudwatch_log_group.log_group.name}",
						"log_stream_name": "${aws_cloudwatch_log_stream.apache_ssl_access_log.name}"
					},
					{
						"file_path": "/var/log/httpd/ssl_error_log",
						"log_group_name": "${aws_cloudwatch_log_group.log_group.name}",
						"log_stream_name": "${aws_cloudwatch_log_stream.apache_ssl_error_log.name}"
					},
					{
						"file_path": "/var/log/httpd/ssl_request_log",
						"log_group_name": "${aws_cloudwatch_log_group.log_group.name}",
						"log_stream_name": "${aws_cloudwatch_log_stream.apache_ssl_request_log.name}"
					}
				]
			}
		}
	},
	"metrics": {
		"append_dimensions": {
			"AutoScalingGroupName": \"\$\{aws:AutoScalingGroupName\}\",
			"ImageId": \"\$\{aws:ImageId\}\",
			"InstanceId": \"\$\{aws:InstanceId\}\",
			"InstanceType": \"\$\{aws:InstanceType\}\"
		},
		"metrics_collected": {
			"collectd": {
				"metrics_aggregation_interval": 60
			},
			"disk": {
				"measurement": [
					"used_percent"
				],
				"metrics_collection_interval": 60,
				"resources": [
					"*"
				]
			},
			"mem": {
				"measurement": [
					"mem_used_percent"
				],
				"metrics_collection_interval": 60
			},
			"statsd": {
				"metrics_aggregation_interval": 60,
				"metrics_collection_interval": 10,
				"service_address": ":8125"
			}
		}
	}
}
EOF
}