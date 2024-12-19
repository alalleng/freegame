
param location string
param aksClusterName string
param clientId string
param clientSecret string

resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-03-01' = {
  name: aksClusterName
  location: location
  properties: {
    kubernetesVersion: '1.26.3'
    dnsPrefix: 'myaks'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 3
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
    servicePrincipalProfile: {
      clientId: clientId
      secret: clientSecret
    }
  }
}