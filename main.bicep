targetScope = 'subscription'

param location string = deployment().location

var networkRGName = 'appgw-demo-network'
var webappRGName = 'appgw-demo-webapp'
var appgwRGName = 'appgw-demo-appgw'

resource networkRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: networkRGName
  location: location
}

resource webappRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: webappRGName
  location: location
}

resource appgwRG 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: appgwRGName
  location: location
}

module lzVnet 'modules/vnet.bicep' = {
  name: 'vnet-lz'
  scope: networkRG
  params: {
    location: location
    vnetName: 'vnet-lz'
    subnets: [
      {
        name: 'appgw'
        properties: {
          addressPrefix: '10.13.0.0/24'
        }
      }
      {
        name: 'appservice-subnet'
        properties: {
          addressPrefix: '10.13.1.0/24'
        }
      }
      {
        name: 'pe-subnet'
        properties: {
          addressPrefix: '10.13.2.0/24'
        }
      }
      {
        name: 'vm-subnet'
        properties: {
          addressPrefix: '10.13.3.0/24'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.13.255.0/24'
        }
      }
    ]
    vnetAddressPrefix: '10.13.0.0/16'
  }
}

module appservice 'modules/appservice.bicep' = {
  name: 'appservice'
  scope: webappRG
  params: {
    aspName: 'asp-demo'
    location: location
    sku: 'S1'
    aspCapacity: 2

    webAppName: 'jk-webapp-demo'
  }
}

module appgw 'modules/appgw.bicep' = {
  name: 'appgw'
  scope: appgwRG
  params: {
    name: 'appgw'
    location: location 
    subnetId: lzVnet.outputs.subnets[0].id
    backendfqdn: appservice.outputs.fqdn[0]
  }
}
