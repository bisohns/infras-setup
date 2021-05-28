terraform {
  backend "s3" {
    bucket = "gophie-terraform-state-c3ba89a7acadc0725dfc"
    region = "eu-west-2"
    key = "global/terrform.tfstate"

    dynamodb_table = ""
    encrypt = true
  }
 }
