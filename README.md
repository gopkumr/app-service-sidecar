# Running a sidecar Container along side an API on App Service 
An experiment deploying dapr as a sidecar in App Service

#  Running locally

## Prerequisite
- docker desktop
- dotnet sdk 9.0

## Steps
From the root of the project run

```bash
docker-compose up
```

Once docker is running, change to the api-app folder and run

```bash
dotnet run
```
This will run the api app and display the endpoint. Use the test.http file to fire both get and set requests.

# Deploying to Azure

## Prerequisite
- Azure Subscription
- Contributor access to subscription
- Access to assign RBAC permission to resources
- Azure CLI Installed
- Docker CLI
- login to azure in the cli using ``az login``

## Steps

Run throught the CLI commands in the file ``deploy-commands.ps1`` one at a time.

To test the deployed code, run the `deployed code` tests in the `test.html`



