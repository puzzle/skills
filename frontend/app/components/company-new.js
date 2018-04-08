import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  store: service(),
  i18n: service(),
  router: service(),

  actions: {
    submit(newCompany) {
      return newCompany.save()
        .then(function() {
        })
        .then(() => this.sendAction('submit', newCompany))
        .then(() => this.get('notify').success('Firma wurde erstellt'))
        .then(function() {
          newCompany.get('locations').toArray().forEach(function(location) {
            newCompany.get('locations').pushObject(location);
            location.save();
          });
          newCompany.get('employeeQuantities').toArray().forEach(function(employeeQuantity) {
            employeeQuantity.save();
          });
        });
    },

    addLocations(company) {
      let location = this.get('store').createRecord('location');
      location.set('company', company);
    },

    addEmployeeQuantity(company) {
      let employeeQuantity = this.get('store').createRecord('employee-quantity');
      employeeQuantity.set('company', company);
    }
  }
});
