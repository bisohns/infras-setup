terraform {
  backend "s3" {
    bucket = "terraform-state-bisoncorps"
    key    = "gophie/global/terraform.state.json"
    region = "eu-west-2"
  }
}
