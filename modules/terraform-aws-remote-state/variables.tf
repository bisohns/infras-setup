variable "bucket_key" {
  description = "The Key to store bucket in"
  default     = "global/terrform.tfstate"
}

variable "bucket_name" {
  description = "Name of bucket to be created. If not provided name is generated from name_prefix appended with a random string"
  default     = ""
}

variable "name_prefix" {
  description = "Prefix for all created resources"
  default     = "tfstate-"
}

variable "dynamo_lock_name" {
  description = "Name of Dynamo lock to be created for lock. If not provided name is generated from name_prefix appended with a random string"
  default     = ""
}

variable "use_lock" {
  description = "Whether to enable locking using dynamo_db"
  default     = true
  type        = bool
}

variable "force_destroy" {
  default     = false
  type        = bool
  description = "Whether to allow a forceful destruction of this bucket"
}

variable "enable_versioning" {
  default     = true
  description = "enables versioning for objects in the S3 bucket"
  type        = bool
}

variable "backend_output_path" {
  default     = "./backend.tf"
  description = "The default file to output backend configuration to"
}

