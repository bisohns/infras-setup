variable "app_name" {
  description = "The name of the heroku app"
}

variable "region" {
  description = "The region to deploy application for new apps"
  default     = null
}

variable "create_new_app" {
  default     = false
  description = "Whether to create a new app or not with the app_name. For existing applications, this should be false"
}

variable "sensitive_config_vars" {
  default     = {}
  description = "Sensitve config variables to be added to the application"
}

variable "config_vars" {
  default     = {}
  description = "Non-sensitive config variables to be added to the application"
}

variable "buildpacks" {
  description = "(Optional) Buildpack names or URLs for the application. Buildpacks configured externally won't be altered if this is not present."
  default     = []
}
