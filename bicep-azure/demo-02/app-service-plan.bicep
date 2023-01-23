resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'toy-product-launch-demo-plan'
  location: 'westus3'
  sku: {
    name: 'F1'
  }
}

resource appServiceApp 'Microsoft.Web/sites@2022-03-01' = {
  name: 'toy-product-launch-1'
  location: 'westus3'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
  }
}
