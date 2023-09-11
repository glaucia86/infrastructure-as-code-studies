terraform {
  backend "azurerm" {
    storage_account_name = "storage-account"
    container_name       = "container-name"
    key                  = "your-tf-state-name"
    access_key           = "your-storage-key"
  }
}
#Recursos para inicializar o projeto 
//Criando Resource Group - rg-piloto
resource "azurerm_resource_group" "rg" {
  name     = "rg-lce-piloto"
  location = "brazilsouth"
  tags     = var.tags
}

//VNET e Subnets
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-piloto"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.21.0.0/16"]
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_subnet" "apimsubnet" {
  name                 = "subnet-apim"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.21.0.0/24"]
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_subnet" "appgwsubnet" {
  name                 = "subnet-appgw"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.21.1.0/24"]
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_subnet" "akssubnet" {
  name                 = "subnet-aks"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.21.2.0/24"]
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_subnet" "pvsubnet" {
  name                 = "subnet-pv"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.21.3.0/24"]
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_public_ip" "pip" {
  name                = "pilotoPublicIPAddress"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  depends_on          = [azurerm_resource_group.rg]
}

resource "azurerm_lb" "loadbalancer" {
  name                = "lb-piloto"
  sku                 = "Standard"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                 = azurerm_public_ip.pip.name
    public_ip_address_id = azurerm_public_ip.pip.id
  }
}

#Recursos contemplados na arquitetura SILCE
//storage
module "storage" {
  source               = "./modules/storage"
  storage_account_name = "storagelcepiloto"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = "brazilsouth"
  depends_on           = [azurerm_resource_group.rg]
}

//private link
module "privatelink" {
  source              = "./modules/privatelink"
  name                = "pllcepiloto"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "brazilsouth"
  subnet_id           = azurerm_subnet.pvsubnet.id
  load_balancer_frontend_ip_configuration_ids               = [azurerm_lb.loadbalancer.frontend_ip_configuration.0.id]
  depends_on          = [azurerm_resource_group.rg]
}

//app gateway
module "appgateway" {
  source              = "./modules/appgateway"
  name                = "ag-sil-lce-piloto"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "brazilsouth"
  subnet_id           = azurerm_subnet.pvsubnet.id
  depends_on          = [azurerm_resource_group.rg]
}

//Keyvault
module "keyvault" {
  source              = "./modules/keyvault"
  vault_name          = "kv-sil-lce-piloto"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "brazilsouth"
  tenant_id           = "tennant-id"
  depends_on               = [azurerm_resource_group.rg]
}

//service bus
module "servicebus" {
  source              = "./modules/servicebus"
  name                = "sb-sil-lce-piloto"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "brazilsouth"
  depends_on               = [azurerm_resource_group.rg]
}

//sql server
module "sqldatabase" {
  source              = "./modules/sqldatabase"
  sql_server_name                = "sqlsilcepiloto"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "brazilsouth"
  sql_version         = "12.0"
  sql_db_name         = "sqldb-sil-lce-piloto"
  admin_username      = "sqladmin"
  admin_password      = "P@ssw0rd123456"
  depends_on               = [azurerm_resource_group.rg]
}
  
//acr
module "acr" {
  source              = "./modules/acr"
  name                = "acrsilcepiloto"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "brazilsouth"
  sku_name            = "Basic"
  depends_on               = [azurerm_resource_group.rg]
}

//exemplo teste aks
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-lce-piloto"
  location            = "brazilsouth"
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-lce-piloto"
  depends_on               = [azurerm_resource_group.rg]

  default_node_pool {
    name       = "default"
    node_count = "2"
    vm_size    = "standard_d2_v2"
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "mem" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  name                  = "mem"
  node_count            = "2"
  vm_size               = "standard_d11_v2"
  
}

//apim
module "apim_service" {
  source              = "./modules/apim"
  apim_name           = "apim-sil-lce-piloto"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "brazilsouth"
  depends_on               = [azurerm_resource_group.rg]
}

//Redis
module "redis" {
  source              = "./modules/azredis"
  redis_name          = "redis-sil-lce-piloto"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "brazilsouth"
  depends_on               = [azurerm_resource_group.rg]
}


