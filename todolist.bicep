extension radius
extension hollowcore

param environment string

resource todolist 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'todolist'
  properties: {
    environment: environment
  }
}

resource frontend 'Hollow.Core/containers@2023-10-01-preview' = {
  name: 'frontend'
  properties: {
    application: todolist.id
    environment: environment
    container: {
      image: 'ghcr.io/radius-project/samples/demo:latest'
      ports: {
        http: {
          containerPort: 3000
        }
      }
      env: {
        CONNECTION_REDIS_HOST: {
          value: 'cache.{context.runtime.kubernetes.namespace}.svc.cluster.local'
        }
        CONNECTION_REDIS_PORT: {
          value: '6379'
        } 
      }
    }
  }
}

// resource cache 'Applications.Datastores/redisCaches@2023-10-01-preview' = {
//   name: 'cache'
//   properties: {
//     application: todolist.id
//     environment: environment
//   }
// }
