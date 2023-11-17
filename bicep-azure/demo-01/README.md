# **[Introduction to Infrastructure as code using Bicep](https://learn.microsoft.com/en-us/training/modules/introduction-to-infrastructure-as-code-using-bicep/)**

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

```powershell
az login
```

This command will open a browser window and you will need to login with your Azure account.

If you have more than one subscription, you can list all subscriptions with the following command:

```powershell
az account list --output table
```

Then, you need to set the subscription you want to use. To do this, run the following command:

```powershell
az account set --subscription <subscription-id>
```

After that, you need to create a resource group. To do this, run the following command:

```powershell
az group create --name storage-resource-group --location eastus
```

Then, you need to create a storage account. To do this, run the following command:

```powershell
az storage account create \
  --name mystorageaccount \
  --resource-group storage-resource-group \
  --location eastus \
  --sku Standard_LRS \
  --kind StorageV2 \  
  --access-tier Hot \
  --https-only true \
```

But, instead of running the command above, create a file called `main.bicep` inside the `demo-01` folder and paste the following content:

```bicep
param location string = resourceGroup().location
param namePrefix string = 'storage'

var storageAccountName = '${namePrefix}${uniqueString(resourceGroup().id)}'
var storageAccountSku = 'Standard_RAGRS'

resource storageAccount = 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageAccountSku
  }
  properties: {
    accessTier: 'Hot'
    supportsHttpsTrafficOnly: true
  }
}

output storageAccountId string = storageAccount.id
```

Then, run the following command:

```powershell
az deployment group create --template-file main.bicep --resource-group storage-resource-group
```

When you type the command above, the storage account resource will be created in Azure.

Se você deseja ver a versão compilada do arquivo `main.bicep`, execute o seguinte comando:

```powershell
bicep build main.bicep
```

Ao digitar esse comando, observe que dentro da pasta `demo-01` será criado um arquivo chamado `main.json`. Esse arquivo é a versão compilada do arquivo `main.bicep`.


