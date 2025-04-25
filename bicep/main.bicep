@description('The Azure region for resource deployment')
param location string

@description('The name of the Resource Group')
param resourceGroupName string

@description('The name of the Virtual Network')
param vnetName string

@description('The address prefix for the Virtual Network')
param addressPrefix string = '10.0.0.0/16'

@description('The address prefix for Subnet 1')
param subnet1Prefix string = '10.0.1.0/24'

@description('The address prefix for Subnet 2')
param subnet2Prefix string = '10.0.2.0/24'

@description('The name of Virtual Machine 1')
param vm1Name string

@description('The name of Virtual Machine 2')
param vm2Name string

@description('The administrator username for the VMs')
param adminUsername string

@secure()
@description('The administrator password for the VMs')
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
