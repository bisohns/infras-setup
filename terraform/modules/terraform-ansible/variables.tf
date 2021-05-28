variable "remote_user" {
  description = "The Remote use to ssh as"
  type        = string
}

variable "scripts_dir" {
  description = "The directory containing all the ansible scripts"
  type        = string
}

variable "private_ssh_key_path" {
  description = "Path to the SSH key to be used to ssh into the server"
  type        = string
}

variable "hosts" {
  description = "A list of hosts that will be used as inventory hosts"
  type        = list(string)
}

variable "entry_script" {
  description = "The ansible script to execute. This can be a full path to the script or just the script name"
  type        = string
}
