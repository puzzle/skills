import Route from '@ember/routing/route';

export default Route.extend({
  model() {
    return this.store.createRecord('company');
  },

  actions: {
    companyCreated(company) {
      this.transitionTo('companies.show', company.id);
    }
  }
});
