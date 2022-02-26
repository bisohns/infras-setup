# terraform-aws

Ansible And Terraform scripts for the Gophie Infrastructure

## Requirements
- Terraform
- [Terraform Namecheap](https://github.com/adamdecaf/terraform-provider-namecheap)
- GCP Credentials
```bash
   $ export GOOGLE_APPLICATION_CREDENTIALS=path-to-cred.json
```

- AWS CLI (or Credentials)
```bash
   # for previously created 'profile'
   $ export AWS_PROFILE=profile
```

- Ansible
```bash
   $ pip install -r requirements.txt
   $ ansible-galaxy install -r ./ansible/requirements.yml
```

## Create Infra
```bash
  $ cd terraform/
  $ terraform apply
```


## Destroy Infra
```bash
  $ cd terraform/
  $ terraform destroy
```
