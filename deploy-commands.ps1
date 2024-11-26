
#Create resource group
az group create --name app-service-sidecar-poc-rg --location australiaeast

#Create Azure Cache for redis
az redis create --location australiaeast --name sidecar-poc-cache --resource-group app-service-sidecar-poc-rg --sku Basic --vm-size c0
az redis update --name sidecar-poc-cache --resource-group app-service-sidecar-poc-rg  --set "redisConfiguration.aadEnabled"="true"

#Create Container Registry
az acr create --name appsrvdevacr --resource-group app-service-sidecar-poc-rg --sku Basic --admin-enabled true

#Push the dapr image to Acr
az acr login --name appsrvdevacr  
docker build -t appsrvdevacr.azurecr.io/dapr-sidecar:v1 --build-arg COMPONENT_PATH=components-deploy ./dapr-statestore/
docker push appsrvdevacr.azurecr.io/dapr-sidecar:v1

# Deploy the app and Create managed identity
cd api-app
az webapp up --name sidecar-app-dev --os-type linux
az webapp identity assign --name sidecar-app-dev --resource-group app-service-sidecar-poc-rg

#Assign the app with pull permission to the registry and contribute to redis cache
$principalId=$(az webapp show --resource-group app-service-sidecar-poc-rg --name sidecar-app-dev  --query "identity.principalId" --output tsv)
$registryId=$(az acr show --resource-group app-service-sidecar-poc-rg --name appsrvdevacr --query id --output tsv)
az role assignment create --assignee $principalId --scope $registryId --role "AcrPull"
az redis access-policy-assignment create -g app-service-sidecar-poc-rg -n sidecar-poc-cache --object-id $principalId --object-id-alias 'dapr-sidecar' --access-policy-name "Data Owner" --policy-assignment-name "dapr-sidecar-data-owner"


#Deploy the sidecar Container
cd ..
az deployment group create --resource-group app-service-sidecar-poc-rg --parameters ./bicep/sidecar-container.bicepparam