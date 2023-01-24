# Step by step to use this demonstration

1. Verify if the bicep is installed and updated

```bash 
az bicep install && az bicep upgrade
```

2. Login to Azure

```bash
az login
```

3. Define the subscription from this lesson `Concierge Subscription`

```bash
az account set --subscription "Concierge Subscription"
```

4. Now try to get the Subscription ID (`Concierge Subscription`)

```bash
az account list \
   --refresh \
   --query "[?contains(name, 'Concierge Subscription')].id" \
   --output table
```

5. Now, we need to define as a standard subscription. Update the script below with the Subscription ID

```bash
az account set --subscription {your subscription ID}
```

6. Set the default resource group 

```bash
az configure --defaults group=learn-5ae9f815-36a9-43e7-ab37-06c07cd0261d
```

7. Deploy the template to Azure

```bash
az deployment group create \
  --template-file main.bicep \
  --parameters main.parameters.dev.json
```

8. Now we will need to include the `sqlServerAdminstratorLogin` and `sqlServerAdminstratorLogin`

```bash
sqlServerAdminstratorLogin: glau@123
sqlServerAdminstratorLogin: Br@zil!2023
```

9. Now we need to create a key vault to store the secrets

```bash
demo-learn-2023glau
```

10. And execute this command below (separatly):

```bash
keyVaultName='YOUR-KEY-VAULT-NAME'
read -s -p "Enter the login name: " login
read -s -p "Enter the password: " password

az keyvault create --name $keyVaultName --location westus3 --enabled-for-template-deployment true
az keyvault secret set --vault-name $keyVaultName --name "sqlServerAdministratorLogin" --value $login --output none
az keyvault secret set --vault-name $keyVaultName --name "sqlServerAdministratorPassword" --value $password --output none
```

/subscriptions/95b7492f-5b2b-49c1-ac98-7905378ab91e/resourceGroups/learn-5ae9f815-36a9-43e7-ab37-06c07cd0261d/providers/Microsoft.KeyVault/vaults/demo-learn-2023glau

