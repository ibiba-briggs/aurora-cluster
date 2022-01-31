## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6 |
| aws | >= 3.8 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.8 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| aurora_mysql_autoscaling | ../../ |  |

## Resources

| Name |
|------|
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/3.8/docs/resources/security_group) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| availability\_zones | The availability zones used by cluster. | `list(string)` | n/a | yes |
| cidr\_blocks | A list of CIDR blocks which are allowed to access the database | `list(string)` | n/a | yes |
| environment | Name of environment being deployed. (e.g. dev, lowers, production) | `string` | n/a | yes |
| master\_password | Master DB password. | `string` | n/a | yes |
| master\_username | Master DB username | `string` | n/a | yes |
| subnet\_group\_ids | A list of VPC subnet IDs. | `list(string)` | n/a | yes |
| tags | A map of tags to assign to the resource. | `map(string)` | <pre>{<br>  "CreatedBy": "Terraform",<br>  "Name": "Aurora-Test"<br>}</pre> | no |
| vpc\_id | The VPC ID. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cluster\_arn | Amazon Resource Name (ARN) of cluster |
| cluster\_id | The RDS Cluster Identifier |
| cluster\_identifier | The RDS Cluster Identifier |
| db\_arns | Amazon Resource Name (ARN) of cluster instances. |
| db\_identifiers | The Instance identifiers. |
| db\_ids | The Instance identifiers. |
| reader\_endpoint | A read-only endpoint for the Aurora cluster, automatically load-balanced across replicas |
| writer\_endpoint | The DNS address of the RDS instance |
