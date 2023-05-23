param aspName string
param location string
param sku string = 'S1'
param aspCapacity int = 1

param webAppName string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: aspName
  location: location
  sku: {
    name: sku
    capacity: aspCapacity
  }
}

resource webApplication 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
}

output fqdn array = webApplication.properties.hostNames
