import Route from '@ember/routing/route';

export default Route.extend({
  model() {
    let company = this.store.createRecord('company');
    return company;
  },

  actions: {
    createCompany(company) {
      this.send('reloadCompaniesList');

      this.transitionTo('companies.show', company);
      //company.get('locations').filterBy('isNew').invoke('unloadRecord');
    }
  }
});
