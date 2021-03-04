terraform {
  backend "s3" {
    bucket = "${remote_state_bucket}"
    region = "${bucket_region}"
    key = "${bucket_key}"

    dynamodb_table = "%{ if use_lock }${dynamodb_table}%{ endif }"
    encrypt = true
  }
 }
