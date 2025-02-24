
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.16.0"
    }
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = var.provider_credentials.subscription_id
  tenant_id                       = var.provider_credentials.tenant_id
  client_id                       = var.provider_credentials.sp_client_id
  client_secret                   = var.provider_credentials.sp_client_secret
  features {}
}


# ------------------------------
# Variables
# ------------------------------
variable "provider_credentials" {
  type = object({
    subscription_id  = string
    tenant_id        = string
    sp_client_id     = string
    sp_client_secret = string
  })
}

variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "container_registry_name" {
  type = string
}

variable "mysql_username" {
  type = string
}

variable "mysql_password" {
  type = string
}

variable "mysql_database" {
  type = string
}

variable "image_container" {
  type = string
}


# ------------------------------
# Resources Group
# ------------------------------
resource "azurerm_resource_group" "rg" {
  name     = "${var.project_name}-${var.environment}-rg"
  location = "Japan East"
}