import Route from '@ember/routing/route';

export default Route.extend({
  queryParams: {
    q: {
      refreshModel: true,
      replace: true
    }
  },

  model({ q }) {
    return this.store.query('skill', { q });
  },
});
