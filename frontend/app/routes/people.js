import { inject as service } from '@ember/service';
import Route from '@ember/routing/route';
import KeycloakAuthenticatedRouteMixin from 'ember-keycloak-auth/mixins/keycloak-authenticated-route';

export default Route.extend(KeycloakAuthenticatedRouteMixin, {
  ajax: service(),

  queryParams: {
    q: {
      refreshModel: true,
      replace: true
    }
  },

  model({ q }) {
    return this.get('ajax').request('/people', { data: { q } })
      .then(response => response.data);
  },

  actions: {
    reloadPeopleList() {
      this.refresh();
    }
  }

});
