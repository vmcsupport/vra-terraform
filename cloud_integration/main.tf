resource "vra_cloud_account_aws" "this" {
  name        = var.vra_project
  description = "terraform test cloud account aws"
  access_key  = var.aws_access_key
  secret_key  = var.aws_secret_key
  regions     = [var.region]
  # Unused capability tags
  #  tags {
  #    key   = "foo"
  #    value = "bar"
  #  }
  # sleep is required to ensure compute resources arse sync'd before the zone is created
  provisioner "local-exec" {
      command = "sleep 30"
  }
}

data "vra_region" "this" {
  cloud_account_id = vra_cloud_account_aws.this.id
  region           = var.region
}

# Configure a new Cloud Zone
resource "vra_zone" "this" {
  name        = join("-", [var.vra_project, var.region, "zone"])
  description = "Cloud Zone configured by Terraform"
  region_id   = data.vra_region.this.id
  
#   tags {
#     key   = "foo"
#      value = "bar"
#    }
}

# Create a new Project
resource "vra_project" "this" {
  name        = join("-", [var.vra_project])
  description = "Project configured by Terraform"

   administrators = ["dg_vmc_asdt_admin@ad.asdt-prod.vmc.internal@ad.asdt-prod.vmc.internal"]
   members = [join("", ["dl_", var.vra_project, "@ad.asdt-prod.vmc.internal@ad.asdt-prod.vmc.internal"])]

  zone_assignments {
    zone_id       = vra_zone.this.id
    priority      = 1
    max_instances = 0
  }
}

data "vra_catalog_source_blueprint" "this" {
  name = "Terraform_Templates"
}

resource "vra_catalog_source_entitlement" "this" {
  catalog_source_id = data.vra_catalog_source_blueprint.this.id
  project_id        = vra_project.this.id
}
