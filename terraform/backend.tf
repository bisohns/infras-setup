terraform {
  backend "s3" {
    bucket = "gophie-terraform-state-eb41fd9ee37117346e4b"
    region = "eu-west-2"
    key = "global/terrform.tfstate"

    dynamodb_table = ""
    encrypt = true
  }
 }
