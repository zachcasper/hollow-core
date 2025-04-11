extension radius

param environment string

resource traderx 'Applications.Core/applications@2023-10-01-preview' = {
  name: 'traderx'
  properties: {
    environment: environment
  }
}

resource database 'Hollow.Core/containers@2023-10-01-preview' = {
  name: 'database'
  properties: {
    application: traderx.id
    container: {
      image: 'ghcr.io/finos/traderx/database:latest'
      ports: {
        tcp: {
          containerPort: 18082
        }
        pg:{
          containerPort: 18083
        }
        web: {
          containerPort: 18084
        }
      }
    }
  }
}

resource referencedata 'Hollow.Core/containers@2023-10-01-preview' = {
  name: 'reference-data'
  properties: {
    application: traderx.id
    container: {
      image: 'ghcr.io/finos/traderx/reference-data:latest'
      ports: {
        web: {
          containerPort: 18085
        }
      }
    }
  }
}

resource tradefeed 'Hollow.Core/containers@2023-10-01-preview' = {
  name: 'trade-feed'
  properties: {
    application: traderx.id
    container: {
      image: 'ghcr.io/finos/traderx/trade-feed:latest'
      ports: {
        web: {
          containerPort: 18086
        }
      }
    }
  }
}

resource peopleservice 'Hollow.Core/containers@2023-10-01-preview' = {
  name: 'people-service'
  properties: {
    application: traderx.id
    container: {
      image: 'ghcr.io/finos/traderx/people-service:latest'
      ports: {
        web: {
          containerPort: 18089
        }
      }
    }
  }
}

resource accountservice 'Hollow.Core/containers@2023-10-01-preview' = {
  name: 'account-service'
  properties: {
    application: traderx.id
    container: {
      image: 'ghcr.io/finos/traderx/account-service:latest'
      ports: {
        web: {
          containerPort: 18088
        }
      }
      env: {
        DATABASE_TCP_HOST: {
          value: database.name
        }
        PEOPLE_SERVICE_HOST: {
          value: peopleservice.name
        }
      }
    }
    connections: {
      peopleservice: {
        source: peopleservice.id
      }
      db: {
        source: database.id
      }
    }
  }
}

resource positionservice 'Hollow.Core/containers@2023-10-01-preview' = {
  name: 'position-service'
  properties: {
    application: traderx.id
    container: {
      image: 'ghcr.io/finos/traderx/position-service:latest'
      ports: {
        web: {
          containerPort: 18090
        }
      }
      env: {
        DATABASE_TCP_HOST: {
          value: database.name
        }
      }
    }
    connections: {
      db: {
        source: database.id
      }
    }
  }
}

resource tradeservice 'Hollow.Core/containers@2023-10-01-preview' = {
  name: 'trade-service'
  properties: {
    application: traderx.id
    container: {
      image: 'ghcr.io/finos/traderx/trade-service:latest'
      ports: {
        web: {
          containerPort: 18092
        }
      }
      env: {
        DATABASE_TCP_HOST: {
          value: database.name
        }
        PEOPLE_SERVICE_HOST: {
          value: peopleservice.name
        }
        ACCOUNT_SERVICE_HOST: {
          value: accountservice.name
        }
        REFERENCE_DATA_HOST: {
          value: referencedata.name
        }
        TRADE_FEED_HOST: {
          value: tradefeed.name
        }
      }
    }
    connections: {
      db: {
        source: database.id
      }
      peopleservice: {
        source: peopleservice.id
      }
      accountservice: {
        source: accountservice.id
      }
      referencedata: {
        source: referencedata.id
      }
      tradefeed: {
        source: tradefeed.id
      }
    }
  }
}

resource tradeprocessor 'Hollow.Core/containers@2023-10-01-preview' = {
  name: 'trade-processor'
  properties: {
    application: traderx.id
    container: {
      image: 'ghcr.io/finos/traderx/trade-processor:latest'
      ports: {
        web: {
          containerPort: 18091
        }
      }
      env: {
        DATABASE_TCP_HOST: {
          value: database.name
        }
        TRADE_FEED_HOST: {
          value: tradefeed.name
        }
      }
    }
    connections: {
      db: {
        source: database.id
      }
      tradefeed: {
        source: tradefeed.id
      }
    }
  }
}

resource webfrontend 'Hollow.Core/containers@2023-10-01-preview' = {
  name: 'web-front-end-angular'
  properties: {
    application: traderx.id
    container: {
      image: 'ghcr.io/finos/traderx/web-front-end-angular:latest'
      ports: {
        web: {
          containerPort: 18093
        }
      }
      env: {
        DATABASE_TCP_HOST: {
          value: database.name
        }
      }
    }
    connections: {
      db: {
        source: database.id
      }
      tradefeed: {
        source: tradefeed.id
      }
    }
  }
}

resource ingress 'Hollow.Core/containers@2023-10-01-preview' = {
  name: 'ingress'
  properties: {
    application: traderx.id
    container: {
      image: 'ghcr.io/finos/traderx/ingress:latest'
      ports: {
        web: {
          containerPort: 8080
        }
      }
      env: {
        DATABASE_TCP_HOST: {
          value: database.name
        }
      }
    }
    connections: {
      db: {
        source: database.id
      }
      tradefeed: {
        source: tradefeed.id
      }
      peopleservice: {
        source: peopleservice.id
      }
      accountservice: {
        source: accountservice.id
      }
      positionservice: {
        source: positionservice.id
      }
      tradeservice: {
        source: tradeservice.id
      }
      tradeprocessor: {
        source: tradeprocessor.id
      }
      webfrontend: {
        source: webfrontend.id
      }
    }
  }
}
