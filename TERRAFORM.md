## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| aws | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0 |
| terraform | n/a |
| tfe | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | Environment or stage that the server is in. | `string` | n/a | yes |
| instance\_size | Size of AWS EC2 instance. | `string` | n/a | yes |
| key\_name | Key pair for personal Wordpress Blog. | `string` | n/a | yes |
| region | AWS region | `string` | n/a | yes |

## Outputs

No output.
