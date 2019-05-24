import Service from '@ember/service';

export default Service.extend({
  tokenParsed: '1234',
  given_name: 'Name',
  token: '1234',
  roles: 'bla',
  keycloak: Object.freeze([{ token: '1234' }]),

  get headers() {},

  hasResourceRole(resource, role) {},

  installKeycloak(parameters) {},

  initKeycloak() {},

  hasRealmRole(role) {},

  _parseRedirectUrl(router, transition) {},

  loadUserProfile() {},

  login(redirectUri) {},

  logout(redirectUri) {},

  checkTransition(transition) {},

  updateToken() {
    return new Promise((resolve, reject) => { resolve() })
  }
})
