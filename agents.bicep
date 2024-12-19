// Parameters for resource names and configurations
param location string = 'eastus'
param aksClusterName string = 'myAKSCluster'
param containerRegistryName string = 'myContainerRegistry'
param keyVaultName string = 'myKeyVault'
param agentCount int = 10

// Resource group
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'myResourceGroup'
  location: location
}

// Container Registry
resource containerRegistry 'Microsoft.ContainerRegistry/registries@2021-06-01-preview' = {
  name: containerRegistryName
  location: location
  sku: {
    name: 'Basic'
  }
}

// Key Vault
resource keyVault 'Microsoft.KeyVault/vaults@2021-04-01' = {
  name: keyVaultName
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        tenantId: subscription().tenantId
        objectId: 'your-object-id'
        permissions: {
          secrets: [
            'get'
            'list'
            'set'
            'delete'
          ]
        }
      }
    ]
  }
}

// AKS Cluster
resource aksCluster 'Microsoft.ContainerService/managedClusters@2021-03-01' = {
  name: aksClusterName
  location: location
  properties: {
    kubernetesVersion: '1.21.2'
    dnsPrefix: 'myaks'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: agentCount
        vmSize: 'Standard_DS2_v2'
        osType: 'Linux'
      }
    ]
    servicePrincipalProfile: {
      clientId: 'your-client-id'
      secret: 'your-client-secret'
    }
  }
}

// Deploy Docker containers for each application
module openNLPContainer 'dockerContainer.bicep' = {
  name: 'openNLPContainer'
  params: {
    containerRegistryName: containerRegistryName
    imageName: 'opennlp'
    imageTag: 'latest'
  }
}

module gateContainer 'dockerContainer.bicep' = {
  name: 'gateContainer'
  params: {
    containerRegistryName: containerRegistryName
    imageName: 'gate'
    imageTag: 'latest'
  }
}

module nltkContainer 'dockerContainer.bicep' = {
  name: 'nltkContainer'
  params: {
    containerRegistryName: containerRegistryName
    imageName: 'nltk'
    imageTag: 'latest'
  }
}

module gensimContainer 'dockerContainer.bicep' = {
  name: 'gensimContainer'
  params: {
    containerRegistryName: containerRegistryName
    imageName: 'gensim'
    imageTag: 'latest'
  }
}

module uimaContainer 'dockerContainer.bicep' = {
  name: 'uimaContainer'
  params: {
    containerRegistryName: containerRegistryName
    imageName: 'uima'
    imageTag: 'latest'
  }
}

module tmContainer 'dockerContainer.bicep' = {
  name: 'tmContainer'
  params: {
    containerRegistryName: containerRegistryName
    imageName: 'tm'
    imageTag: 'latest'
  }
}

module patternContainer 'dockerContainer.bicep' = {
  name: 'patternContainer'
  params: {
    containerRegistryName: containerRegistryName
    imageName: 'pattern'
    imageTag: 'latest'
  }
}

module carrot2Container 'dockerContainer.bicep' = {
  name: 'carrot2Container'
  params: {
    containerRegistryName: containerRegistryName
    imageName: 'carrot2'
    imageTag: 'latest'
  }
}

module knimeContainer 'dockerContainer.bicep' = {
  name: 'knimeContainer'
  params: {
    containerRegistryName: containerRegistryName
    imageName: 'knime'
    imageTag: 'latest'
  }
}

module mahoutContainer 'dockerContainer.bicep' = {
  name: 'mahoutContainer'
  params: {
    containerRegistryName: containerRegistryName
    imageName: 'mahout'
    imageTag: 'latest'
  }
}

module hpccContainer 'dockerContainer.bicep' = {
  name: 'hpccContainer'
  params: {
    containerRegistryName: containerRegistryName
    imageName: 'hpcc'
    imageTag: 'latest'
  }
}

module thriftContainer 'dockerContainer.bicep' = {
  name: 'thriftContainer'
  params: {
    containerRegistryName: containerRegistryName
    imageName: 'thrift'
    imageTag: 'latest'
  }
}

module nlpPlusPlusContainer 'dockerContainer.bicep' = {
  name: 'nlpPlusPlusContainer'
  params: {
    containerRegistryName: containerRegistryName
    imageName: 'nlp++'
    imageTag: 'latest'
  }
}

module whisperAI 'aiAgent.bicep' = {
  name: 'whisperAI'
  params: {
    location: location
    agentName: 'whisperAI'
    apiKey: 'your-whisper-api-key'
  }
}

module searchAgent 'aiAgent.bicep' = {
  name: 'searchAgent'
  params: {
    location: location
    agentName: 'searchAgent'
    apiKey: 'your-search-api-key'
  }
}

// Docker Container Module (dockerContainer.bicep)
param containerRegistryName string
param imageName string
param imageTag string

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-03-01' = {
  name: '${imageName}-group'
  location: location
  properties: {
    containers: [
      {
        name: imageName
        properties: {
          image: '${containerRegistryName}.azurecr.io/${imageName}:${imageTag}'
          resources: {
            requests: {
              cpu: 1
              memoryInGb: 1.5
            }
          }
        }
      }
    ]
    osType: 'Linux'
  }
}
