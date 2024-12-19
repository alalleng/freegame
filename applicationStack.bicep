
param location string
param appServicePlanName string
param apiManagementName string
param functionAppName string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
  }
}

resource apiManagement 'Microsoft.ApiManagement/service@2023-03-01-preview' = {
  name: apiManagementName
  location: location
  sku: {
    name: 'Developer'
    capacity: 1
  }
  properties: {
    publisherEmail: 'admin@mycompany.com'
    publisherName: 'My Company'
  }
}

resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: functionAppName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlan.id
    // ...additional properties...
  }
}