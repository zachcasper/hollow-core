# Hollow Core

Prototype implementation of Applications.Core/containers using only Radius resource types and Bicep recipes.

## Set Up

Create the Hollow.Core/containers resource type.
```
rad resource-type create containers -f types.yaml
```
Create the Bicep extension.
```
rad bicep publish-extension  -f types.yaml --target hollowcore.tgz
```
Publish the Bicep template.
```
rad bicep publish --file recipes/containers.bicep --target br:ghcr.io/zachcasper/hollow-core/containers:latest
```
**Note**: Ensure the image is publicly accessible.

Register the recipe.
```
rad recipe register default \
  --environment hollow \
  --resource-type Hollow.Core/containers \
  --template-kind bicep \
  --template-path ghcr.io/zachcasper/hollow-core/containers:latest
```

## Run todolist
```
rad deploy todolist.bicep
```