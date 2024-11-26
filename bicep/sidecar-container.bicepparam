using './sidecar-container.bicep'

param appServiceName = 'sidecar-app-dev'
param sidecarName = 'dapr-sidecar'
param sidecarImage = 'appsrvdevacr.azurecr.io/dapr-sidecar:v5'

