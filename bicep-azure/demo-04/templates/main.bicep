@description('The Azure regions into which the resources should be deployed.')
param locations array = [
  'westeurope'
  'eastus2'
]

@secure()
@description('The administrator login username for the SQL server.')
param sqlServerAdminstratorLogin string

@secure()
@description('The administrator login password for the SQL server.')
param sqlServerAdminstratorLoginPassword string

module databases '../modules/database.bicep' = [for location in locations: {
  name: 'database-${location}'
  params: {
    location: location
    sqlServerAdminstratorLogin: sqlServerAdminstratorLogin
    sqlServerAdminstratorLoginPassword: sqlServerAdminstratorLoginPassword
  }
}]
