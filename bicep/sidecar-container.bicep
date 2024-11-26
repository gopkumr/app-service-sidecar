param appServiceName string
param sidecarName string
param sidecarImage string


resource sidecar_app_dev_dapr_sidecar 'Microsoft.Web/sites/sitecontainers@2024-04-01' = {
  name: '${appServiceName}/${sidecarName}'
  properties: {
    image: sidecarImage
    isMain: false
    authType: 'SystemIdentity'
    volumeMounts: []
    environmentVariables: []
  }
}
