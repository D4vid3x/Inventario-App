import Keycloak from 'keycloak-js'

const keycloak = new Keycloak({
  url: 'http://localhost:8080',
  realm: 'inventario',
  clientId: 'inventario-app',
})

export default keycloak
