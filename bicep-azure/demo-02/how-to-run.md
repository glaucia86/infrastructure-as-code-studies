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
az configure --defaults group=learn-66bfb9c0-5c99-4cd7-9704-7dff015cee48
```

7. Deploy the template to Azure

```bash
az deployment group create \
  --template-file main.bicep \
  --parameters environmentType=nonprod
```

