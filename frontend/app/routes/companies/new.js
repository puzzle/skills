import Route from '@ember/routing/route';

export default Route.extend({
  model() {
    let company = this.store.createRecord('company');
    let location = this.store.createRecord('location');
    location.set('company', company);
    return Ember.RSVP.hash( {
      company, location
    });
  },

  locationModel() {
    return this.store.createRecord('location');
  },

  actions: {
    createCompany(company) {
      this.send('reloadCompaniesList');
    }
  }
});
