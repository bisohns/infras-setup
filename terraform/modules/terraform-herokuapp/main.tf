locals {
  app_id = var.create_new_app == false ? data.heroku_app.app.0.id : heroku_app.app.0.id
}

data "heroku_app" "app" {
  count = var.create_new_app == false ? 1 : 0
  name  = var.app_name
}

resource "heroku_config" "app" {
  vars = var.config_vars

  sensitive_vars = var.sensitive_config_vars
}

resource "heroku_app" "app" {
  count  = var.create_new_app == false ? 0 : 1
  name   = var.app_name
  region = var.region

  buildpacks = var.buildpacks
}

resource "heroku_app_config_association" "foobar" {
  app_id = local.app_id

  vars           = heroku_config.app.vars
  sensitive_vars = heroku_config.app.sensitive_vars
}
