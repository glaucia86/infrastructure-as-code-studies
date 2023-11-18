# **[Build your first Bicep template](https://learn.microsoft.com/en-us/training/modules/build-first-bicep-template/)

## Pre-requisites

Firstly, you need to install the following programs:

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Install Bicep CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-cli)
- [Visual Studio Code](https://code.visualstudio.com/)
- [Bicep extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep)
- [Azure Account](https://azure.microsoft.com/en-us/free/)

> note: you will need to observe which version of your operating system (32 or 64 bits) to download the correct version of Azure CLI and included Bicep CLI.

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

After that, you need to create a resource group. To do this, run the following command:

```bash
az group create --name storage-resource-group --location eastus
```

Then, you need to create a storage account. To do this, run the following command:

```bash
az storage account create \
  --name mystorageaccount \
  --resource-group storage-resource-group \
  --location eastus \
  --sku Standard_LRS \
  --kind StorageV2 \  
  --access-tier Hot \
  --https-only true \
```

But, instead of running the command above, create a file called `main.bicep` inside the `demo-02 > templates` folder and paste the following content:

```bicep
@description('Specifies the location for resources.')
param location string = 'westus3'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'toylaunchstorageglau02'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}
```

Then, run the following command:

```bash
az configure --defaults group=learn-c4f44288-e5a5-4b1b-881b-1e001096a70b
```

```powershell
az deployment group create --template-file main.bicep
```

If you want to see the implementation of the model, run the following command:

```bash
az deployment group list --output table
```

## Adicionando mais recursos ao modelo

To add more resources to the model, you can add more resources to the `main.bicep` file. For example, to add a storage account resource, you can add the following code: (**at the end of the file**)

```bicep
@description('Specifies the location for resources.')
param location string = 'westus3'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: 'toylaunchstorageglau02'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'toy-product-launch-plan-starter'
  location: location
  sku: {
    name: 'F1'
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'toy-product-launch-app-glau02'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
```

Then, run the following command:

```bash
az deployment group create --template-file main.bicep
```

## Exercise - Add parameters and variables to your Bicep template

```bicep
@description('Specifies the location for resources.')
param location string = 'westus3'

@description('Specifies the name of the storage account.')
param storageAccountName string = 'toylaunch${uniqueString(resourceGroup().id)}'

@description('Specifies the name of the app service plan.')
param appServicePlanName string = 'toylaunch${uniqueString(resourceGroup().id)}'

@allowed([
  'nonprod'
  'prod'
])
param environmentType string

var appServiceAppName = 'toy-product-launch-app-glau02'
var storageAccountSkuName = (environmentType == 'prod') ? 'Standard_GRS' : 'Standard_LRS'
var appServicePlanSkuName = (environmentType == 'prod') ? 'P2v3' : 'F1'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
``` 

Then run the following command:

```bash
az deployment group create --template-file main.bicep --parameters environmentType=nonprod
```

Code developed: **[commit](https://github.com/glaucia86/infrastructure-as-code-studies/commit/bebc5a60dc6cb64ab7ed6c54a8500c882c75ef09)**

## Exercise - Refactor your template to use modules

Code developed: **[commit](https://github.com/glaucia86/infrastructure-as-code-studies/commit/7674f23e0ccf1269c7c3c13998951e0dc623573e)**


