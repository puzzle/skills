import Route from '@ember/routing/route';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Route.extend(AuthenticatedRouteMixin, {
  queryParams: {
    q: {
      refreshModel: true,
      replace: true
    }
  },

  model({ q }) {
    return q ? this.store.query('person', { q }) : q
  },
});
