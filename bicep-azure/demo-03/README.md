**[Build reusable Bicep templates by using parameters](https://learn.microsoft.com/en-us/training/modules/build-reusable-bicep-templates-parameters/)**

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

Now, go to the `demo-03 > templates` folder and create a file called `main.bicep` and paste the following content:

```bicep
@description('The name of the environment. This must be dev, test, or prod.')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'dev'

@description('The unique name of the solution. This is used to ensure that resource names are unique.')
@minLength(5)
@maxLength(30)
param solutionName string = 'toyhr${uniqueString(resourceGroup().id)}'

@description('The number of App Service plan instances.')
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int = 1

@description('The name and tier of the App Service plan SKU.')
param appServicePlanSku object = {
  name: 'F1'
  tier: 'Free'
}

@description('The Azure region into which the resources should be deployed.')
param location string = 'westus3'

var appServicePlanName = '${environmentName}-${solutionName}-plan'
var appServiceAppName = '${environmentName}-${solutionName}-app'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku.name
    tier: appServicePlanSku.tier
    capacity: appServicePlanInstanceCount
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-09-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
```

Firstly, we need to define the resources. For this, run the following command:

```bash
az configure --defaults group=learn-26d6aba4-45e7-4577-a660-8db1fe77334a
```

Now, open the terminal and run the following command: (under the `demo-03 > templates` folder)

```bash
az deployment group create --template-file main.bicep
```

You will see the following output:

<details><summary>Output</summary>

```bash
{
  "id": "/subscriptions/18974119-7a45-4077-9932-f95c83cee0e3/resourceGroups/learn-26d6aba4-45e7-4577-a660-8db1fe77334a/providers/Microsoft.Resources/deployments/main",
  "location": null,
  "name": "main",
  "properties": {
    "correlationId": "d781bd75-bcb5-4001-8bfe-d9c2fc34f8ab",
    "debugSetting": null,
    "dependencies": [
      {
        "dependsOn": [
          {
            "id": "/subscriptions/18974119-7a45-4077-9932-f95c83cee0e3/resourceGroups/learn-26d6aba4-45e7-4577-a660-8db1fe77334a/providers/Microsoft.Web/serverfarms/dev-toyhrdvlbeuedp5qoa-plan",
            "resourceGroup": "learn-26d6aba4-45e7-4577-a660-8db1fe77334a",
            "resourceName": "dev-toyhrdvlbeuedp5qoa-plan",
            "resourceType": "Microsoft.Web/serverfarms"
          }
        ],
        "id": "/subscriptions/18974119-7a45-4077-9932-f95c83cee0e3/resourceGroups/learn-26d6aba4-45e7-4577-a660-8db1fe77334a/providers/Microsoft.Web/sites/dev-toyhrdvlbeuedp5qoa-app",
        "resourceGroup": "learn-26d6aba4-45e7-4577-a660-8db1fe77334a",
        "resourceName": "dev-toyhrdvlbeuedp5qoa-app",
        "resourceType": "Microsoft.Web/sites"
      }
    ],
    "duration": "PT31.2427727S",
    "error": null,
    "mode": "Incremental",
    "onErrorDeployment": null,
    "outputResources": [
      {
        "id": "/subscriptions/18974119-7a45-4077-9932-f95c83cee0e3/resourceGroups/learn-26d6aba4-45e7-4577-a660-8db1fe77334a/providers/Microsoft.Web/serverfarms/dev-toyhrdvlbeuedp5qoa-plan",
        "resourceGroup": "learn-26d6aba4-45e7-4577-a660-8db1fe77334a"
      },
      {
        "id": "/subscriptions/18974119-7a45-4077-9932-f95c83cee0e3/resourceGroups/learn-26d6aba4-45e7-4577-a660-8db1fe77334a/providers/Microsoft.Web/sites/dev-toyhrdvlbeuedp5qoa-app",
        "resourceGroup": "learn-26d6aba4-45e7-4577-a660-8db1fe77334a"
      }
    ],
    "outputs": null,
    "parameters": {
      "appServicePlanInstanceCount": {
        "type": "Int",
        "value": 1
      },
      "appServicePlanSku": {
        "type": "Object",
        "value": {
          "name": "F1",
          "tier": "Free"
        }
      },
      "environmentName": {
        "type": "String",
        "value": "dev"
      },
      "location": {
        "type": "String",
        "value": "westus3"
      },
      "solutionName": {
        "type": "String",
        "value": "toyhrdvlbeuedp5qoa"
      }
    },
    "parametersLink": null,
    "providers": [
      {
        "id": null,
        "namespace": "Microsoft.Web",
        "providerAuthorizationConsentState": null,
        "registrationPolicy": null,
        "registrationState": null,
        "resourceTypes": [
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              "westus3"
            ],
            "properties": null,
            "resourceType": "serverfarms",
            "zoneMappings": null
          },
          {
            "aliases": null,
            "apiProfiles": null,
            "apiVersions": null,
            "capabilities": null,
            "defaultApiVersion": null,
            "locationMappings": null,
            "locations": [
              "westus3"
            ],
            "properties": null,
            "resourceType": "sites",
            "zoneMappings": null
          }
        ]
      }
    ],
    "provisioningState": "Succeeded",
    "templateHash": "4670921461777091649",
    "templateLink": null,
    "timestamp": "2023-11-27T20:19:11.448183+00:00",
    "validatedResources": null
  },
  "resourceGroup": "learn-26d6aba4-45e7-4577-a660-8db1fe77334a",
  "tags": null,
  "type": "Microsoft.Resources/deployments"
}
```
</details>

Finally, open your Azure Portal and check the resources created.

## Exercise - Add a parameter file and secure parameters

In this exercise, you will add a parameter file to your Bicep template and secure the parameters.

Use the same Bicep template from the previous exercise and update the `main.bicep` file with the following content:

```bicep
@description('The name of the environment. This must be dev, test, or prod.')
@allowed([
  'dev'
  'test'
  'prod'
])
param environmentName string = 'dev'

@description('The unique name of the solution. This is used to ensure that resource names are unique.')
@minLength(5)
@maxLength(30)
param solutionName string = 'toyhr${uniqueString(resourceGroup().id)}'

@description('The number of App Service plan instances.')
@minValue(1)
@maxValue(10)
param appServicePlanInstanceCount int = 1

@description('The name and tier of the App Service plan SKU.')
param appServicePlanSku object

@description('The Azure region into which the resources should be deployed.')
param location string = 'westus3'

@description('The administrator login username for the SQL server.')
@secure()
param sqlServerAdministratorLogin string

@description('The administrator login password for the SQL server.')
@secure()
param sqlServerAdministratorPassword string

@description('The name and tier of the SQL database SKU.')
param sqlDatabaseSku object

var appServicePlanName = '${environmentName}-${solutionName}-plan'
var appServiceAppName = '${environmentName}-${solutionName}-app'
var sqlServerName = '${environmentName}-${solutionName}-sql'
var sqlDatabaseName = 'Employees'

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSku.name
    tier: appServicePlanSku.tier
    capacity: appServicePlanInstanceCount
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-09-01' = {
  name: appServiceAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}

resource sqlServer 'Microsoft.Sql/servers@2023-05-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorPassword
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-02-01-preview' = {
  parent: sqlServer
  name: sqlDatabaseName
  location: location
  sku: {
    name: sqlDatabaseSku.name
    tier: sqlDatabaseSku.tier
  }
}
```

Under the folder `demo-03 > templates`, create a file called `main.parameters.dev.json` and include the following content:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appServicePlanSku": {
      "value": {
        "name": "F1",
        "tier": "Free"
      }
    },
    "sqlDatabaseSku": {
      "value": {
        "name": "Standard",
        "tier": "Standard"
      }
    }
  }
}
```

Now, let's implement this template. For this, run the following command:

```bash
az deployment group create --template-file main.bicep --parameters main.parameters.dev.json
```

> Will be ask to include the `sqlServerAdministratorLogin` and `sqlServerAdministratorPassword` parameters. You can use the following values: `sqladmin` and `P@ssw0rd1234`.

Now we are going to use Azure Key Vault. For this open the terminal and run the following command:

```bash
keyVaultName='YOUR-KEY-VAULT-NAME' (keyVaultName='toy-key-vault-sample')
read -s -p "Enter the login name: " login
read -s -p "Enter the password: " password

az keyvault create --name $keyVaultName --location westus3 --enabled-for-template-deployment true
az keyvault secret set --vault-name $keyVaultName --name "sqlServerAdministratorLogin" --value $login --output none
az keyvault secret set --vault-name $keyVaultName --name "sqlServerAdministratorPassword" --value $password --output none
```

To obtain the resource Id from the Azure Key Vault, run the following command:

```bash
az keyvault show --name $keyVaultName --query id --output tsv
```

Copy the output; because we will use it in the next step.

To add a reference to the Azure Key Vault, open the `main.parameters.dev.json` file and add the following content:

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "appServicePlanSku": {
      "value": {
        "name": "F1",
        "tier": "Free"
      }
    },
    "sqlDatabaseSku": {
      "value": {
        "name": "Standard",
        "tier": "Standard"
      }
    },
    "sqlServerAdministratorLogin": {
      "reference": {
        "keyVault": {
          "id": "/subscriptions/18974119-7a45-4077-9932-f95c83cee0e3/resourceGroups/learn-26d6aba4-45e7-4577-a660-8db1fe77334a/providers/Microsoft.KeyVault/vaults/toy-key-vault-sample"
        },
        "secretName": "sqlServerAdministratorLogin"
      }
    },
    "sqlServerAdministratorPassword": {
      "reference": {
        "keyVault": {
          "id": "/subscriptions/18974119-7a45-4077-9932-f95c83cee0e3/resourceGroups/learn-26d6aba4-45e7-4577-a660-8db1fe77334a/providers/Microsoft.KeyVault/vaults/toy-key-vault-sample"
        },
        "secretName": "sqlServerAdministratorPassword"
      }
    }
  }
}
```

Now, let's implement this template. For this, run the following command:

```bash
az deployment group create --template-file main.bicep --parameters main.parameters.dev.json
```
