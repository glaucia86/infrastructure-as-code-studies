**[Build flexible Bicep templates by using conditions and loops](https://learn.microsoft.com/en-us/training/modules/build-flexible-bicep-templates-conditions-loops/)**

## Pre-requisites

Firstly, you need to install the following programs:

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Install Bicep CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-cli)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Bicep extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
- [Azure Account](https://azure.microsoft.com/en-us/free/)

## How to run the demonstration

Firstly you need to use Azure CLI. To do this, you need to install Azure CLI on your computer. To do this, follow the instructions at [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest).

Open the Power Shell and run the following command:

```bash
az login
```

This command will open a browser window and you will need to login with your Azure account.

If you have more than one subscription, you can list all subscriptions with the following command:

```bash
az account list --output table
```

Then, you need to set the subscription you want to use. To do this, run the following command:

```bash
az account set --subscription <subscription-id>
```

## Exercise - Deploy resources conditionally

Link to the exercise: **[HERE](https://learn.microsoft.com/pt-br/training/modules/build-flexible-bicep-templates-conditions-loops/3-exercise-conditions?pivots=cli)**

Create a new file named `main.bicep` and copy the following code into it:

```bicep
@description('The Azure region into which the resources should be deployed')
param location string

@secure()
@description('The administrator login username for the SQL Server')
param sqlServerAdminstratorLogin string

@secure()
@description('The administrator login password for the SQL Server')
param sqlServerAdminstratorLoginPassword string

@description('The name and tier of the SQL database SKU')
param sqlDatabaseSku object = {
  name: 'Standard'
  tier: 'Standard'
}

var sqlServerName = 'teddy${location}${uniqueString(resourceGroup().id)}'
var sqlDatabaseName = 'TeddyBear'

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlServerAdminstratorLogin
    administratorLoginPassword: sqlServerAdminstratorLoginPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2023-05-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: sqlDatabaseSku
}
```

Now let's include the storage account. Add the following code to the end of the file:

```bicep
(... code above ...)

@description('The name of the environment into which the resources should be deployed')
@allowed([
  'Development'
  'Production'
])
param environmentName string = 'Development'

@description('The name of the storage account to use for audit logs')
param auditStorageAccountSkuName string = 'Standard_LRS'

var sqlServerName = 'teddy${location}${uniqueString(resourceGroup().id)}'
var sqlDatabaseName = 'TeddyBear'

var auditingEnabled = environmentName == 'Production'
var auditStorageAccountName = take('bearaudit${location}${uniqueString(resourceGroup().id)}', 24)

(...more code below...)

(... include the storage account in the end of the file...)

resource auditStorageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' = if (auditingEnabled) {
  name: auditStorageAccountName
  location: location
  sku: {
    name: auditStorageAccountSkuName
  }
  kind: 'StorageV2'
}
```

This is the final code:

```bicep
@description('The Azure region into which the resources should be deployed.')
param location string

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdministratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdministratorLoginPassword string

@description('The name and tier of the SQL database SKU.')
param sqlDatabaseSku object = {
  name: 'Standard'
  tier: 'Standard'
}

@description('The name of the environment. This must be Development or Production.')
@allowed([
  'Development'
  'Production'
])
param environmentName string = 'Development'

@description('The name of the audit storage account SKU.')
param auditStorageAccountSkuName string = 'Standard_LRS'

var sqlServerName = 'teddy${location}${uniqueString(resourceGroup().id)}'
var sqlDatabaseName = 'TeddyBear'
var auditingEnabled = environmentName == 'Production'
var auditStorageAccountName = take('bearaudit${location}${uniqueString(resourceGroup().id)}', 24)

resource sqlServer 'Microsoft.Sql/servers@2021-11-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorLoginPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: sqlDatabaseSku
}

resource auditStorageAccount 'Microsoft.Storage/storageAccounts@2021-09-01' = if (auditingEnabled) {
  name: auditStorageAccountName
  location: location
  sku: {
    name: auditStorageAccountSkuName
  }
  kind: 'StorageV2'  
}

resource sqlServerAudit 'Microsoft.Sql/servers/auditingSettings@2021-11-01-preview' = if (auditingEnabled) {
  parent: sqlServer
  name: 'default'
  properties: {
    state: 'Enabled'
    storageEndpoint: environmentName == 'Production' ? auditStorageAccount.properties.primaryEndpoints.blob : ''
    storageAccountAccessKey: environmentName == 'Production' ? listKeys(auditStorageAccount.id, auditStorageAccount.apiVersion).keys[0].value : ''
  }
}
```

