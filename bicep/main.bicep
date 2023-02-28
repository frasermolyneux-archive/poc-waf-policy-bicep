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

// Outputs
output resourceGroups array = [for (location, i) in locations: {
  location: location
  name: rg[i].name
}]
