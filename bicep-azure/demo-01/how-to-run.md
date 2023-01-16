# Step by step to use this demonstration

1. Login to Azure

```bash
az login
```

2. Create a resource group

```bash
az group create \
    --name storage-resource-group \
    --location eastus
```

3. Create a storage account

```bash
#!/usr/bin/env bash
az group create \
    --name storage-resource-group \
    --location eastus

az storage account create \
    --name mystorageaccount \
    --resource-group storage-resource-group \
    --kind StorageV2 \
    --access-tier Hot \
    --https-only true
```
4. Run the script

```bash
az deployment group create --template-file ./main.bicep --resource-group storage-resource-group
```

5. And then execute the script

```bash
bicep build ./main.bicep
```

6. Open the Azure Portal and check the resources created

7. If so, delete the resource group

```bash
az group delete --name storage-resource-group
```

