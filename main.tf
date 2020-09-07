provider "azurerm" {
  version = "~>2.0"
  features {
  }
  subscription_id = "fea15197-9901-4f8d-ac23-10eeb319a5ea"
}

resource "azurerm_resource_group" "rg" {
  name = "test-group"
  location = "japaneast"
}

resource "azurerm_container_registry" "acr" {
  name = "testforappinacr"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Basic"
  admin_enabled = true
}

resource "azurerm_app_service_plan" "app" {
  name = "app_service_plan01"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind = "Linux"
  reserved = true
  sku {
    tier = "Basic"
    size = "S1"
  }
}

resource "azurerm_app_service" "app01" {
  name = "test-for-appin-webapp-01"
  location = azurerm_resource_group.rg.location
  app_service_plan_id = azurerm_app_service_plan.app.id
  resource_group_name = azurerm_resource_group.rg.name
  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/hello:only-logback"
  }
  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL" = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
    "WEBSITES_PORT" = "80"
  }
}

resource "azurerm_application_insights" "appin01" {
  name = "test-for-appin-appi01"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type = "web"
}

resource "azurerm_app_service_plan" "app02" {
  name = "app_service_plan02"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind = "Linux"
  reserved = true
  sku {
    tier = "Basic"
    size = "S1"
  }
}

resource "azurerm_app_service" "app02" {
  name = "test-for-appin-webapp-02"
  location = azurerm_resource_group.rg.location
  app_service_plan_id = azurerm_app_service_plan.app02.id
  resource_group_name = azurerm_resource_group.rg.name
  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/hello:logback-with-xml"
  }
  app_settings = {
    "DOCKER_REGISTRY_SERVER_URL" = "https://${azurerm_container_registry.acr.login_server}"
    "DOCKER_REGISTRY_SERVER_USERNAME" = azurerm_container_registry.acr.admin_username
    "DOCKER_REGISTRY_SERVER_PASSWORD" = azurerm_container_registry.acr.admin_password
    "WEBSITES_PORT" = "80"
  }
}

resource "azurerm_application_insights" "appin02" {
  name = "test-for-appin-appi02"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  application_type = "web"
}
