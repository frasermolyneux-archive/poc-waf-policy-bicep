targetScope = 'subscription'

// Parameters
param environment string
param workload string
param primaryLocation string
param locations array

param tags object

// Variables
var environmentUniqueId = uniqueString(environment, workload)

// Module Resources
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = [for location in locations: {
  name: 'rg-${environmentUniqueId}-${environment}-${location}'
  location: location
  tags: tags

  properties: {}
}]

module frontDoorWafPolicy 'modules/frontDoorWafPolicy.bicep' = {
  name: 'frontDoorWafPolicy'
  scope: resourceGroup('rg-${environmentUniqueId}-${environment}-${primaryLocation}')

  params: {
    policyName: 'fdwaf${environmentUniqueId}${environment}'
  }

  dependsOn: [
    rg
  ]
}

// Outputs
output resourceGroups array = [for (location, i) in locations: {
  location: location
  name: rg[i].name
}]
