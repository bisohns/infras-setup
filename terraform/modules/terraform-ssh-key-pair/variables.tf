variable "algorithm" {
  description = "The name of the algorithm to use for the key. Currently-supported values are 'RSA' and 'ECDSA'."
  default     = "RSA"
}

variable "output_file_path" {
  description = "The Path to store the SSH Key"
  default     = null
}

variable "file_permission" {
  description = "The file permission of the generated ssh key"
  default     = "0400"
}
