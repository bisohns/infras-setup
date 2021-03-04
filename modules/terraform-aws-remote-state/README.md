# Terraform AWS Remote State Module
A terraform module to automate creation and configuration of backend using S3 bucket

## Usage

```hcl
provider "aws" {
  region  = "us-east-2" # Bucket is created in the same region
}

module "remote_state_locking" {
  source   = "git::https://gitlab.com/deimosdev/tooling/terraform-modules/terraform-aws-remote-state"
  use_lock = false
}
```

This creates a `backend.tf` file in the specified `backend_output_path` (default: project directory). Apply the configured backend by running `terraform init` again


## Doc generation

Code formatting and documentation for variables and outputs is generated using [pre-commit-terraform hooks](https://github.com/antonbabenko/pre-commit-terraform) which uses [terraform-docs](https://github.com/segmentio/terraform-docs).

Follow [these instructions](https://github.com/antonbabenko/pre-commit-terraform#how-to-install) to install pre-commit locally.

And install `terraform-docs` with
```bash
go get github.com/segmentio/terraform-docs
```
or
```bash
brew install terraform-docs.
```

## Contributing

Report issues/questions/feature requests on in the issues section.

Full contributing guidelines are covered [here](CONTRIBUTING.md).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | ~> 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.0.0 |
| null | n/a |
| random | n/a |
| template | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backend\_output\_path | The default file to output backend configuration to | `string` | `"./backend.tf"` | no |
| bucket\_key | The Key to store bucket in | `string` | `"global/terrform.tfstate"` | no |
| bucket\_name | Name of bucket to be created. If not provided name is generated from name\_prefix appended with a random string | `string` | `""` | no |
| dynamo\_lock\_name | Name of Dynamo lock to be created for lock. If not provided name is generated from name\_prefix appended with a random string | `string` | `""` | no |
| enable\_versioning | enables versioning for objects in the S3 bucket | `bool` | `true` | no |
| force\_destroy | Whether to allow a forceful destruction of this bucket | `bool` | `false` | no |
| name\_prefix | Prefix for all created resources | `string` | `"tfstate-"` | no |
| use\_lock | Whether to enable locking using dynamo\_db | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket\_name | bucket name |
| dynamodb\_table | Dynamodb name |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->