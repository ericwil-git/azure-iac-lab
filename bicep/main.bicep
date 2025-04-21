param location string = 'eastus'
param resourceGroupName string
param vnetName string
param addressPrefix string = '10.0.0.0/16'
param subnet1Prefix string = '10.0.1.0/24'
param subnet2Prefix string = '10.0.2.0/24'
param vm1Name string
param vm2Name string
param adminUsername string
@secure()
param adminPassword string

resource vnet 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'subnet1'
        properties: {
          addressPrefix: subnet1Prefix
        }
      }
      {
        name: 'subnet2'
        properties: {
          addressPrefix: subnet2Prefix
        }
      }
    ]
  }
}

module vm1 './vm.bicep' = {
  name: 'vm1Deployment'
  params: {
    location: location
    vmName: vm1Name
    subnetId: vnet.properties.subnets[0].id
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module vm2 './vm.bicep' = {
  name: 'vm2Deployment'
  params: {
    location: location
    vmName: vm2Name
    subnetId: vnet.properties.subnets[1].id
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}