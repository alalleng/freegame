param location string
param agentName string
param apiKey string

resource aiAgent 'Microsoft.CognitiveServices/accounts@2023-01-01' = {
  name: agentName
  location: location
  sku: {
    name: 'S0'
  }
  kind: 'CognitiveServices'
  properties: {
    apiProperties: {
      apiKey: apiKey
      // ...additional properties...
    }
  }
}
