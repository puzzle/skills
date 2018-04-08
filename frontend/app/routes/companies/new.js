import Route from '@ember/routing/route';

export default Route.extend({
  model() {
    let company = this.store.createRecord('company');
    return company;
  },

  actions: {
    createCompany(company) {
      let id = company.get('id');
      this.send('reloadCompaniesList');
      this.transitionTo('companies.show', id).then(() => window.location.reload());
    }
  }
});
