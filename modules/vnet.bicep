param location string
param vnetName string
param vnetAddressPrefix string
param subnets array

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: subnets
  }
}

output subnets array = virtualNetwork.properties.subnets
output vnetId string = virtualNetwork.id
output vnetName string = virtualNetwork.name
