import Component from '@ember/component';
import { inject as service } from '@ember/service';

export default Component.extend({
  store: service(),
  i18n: service(),

  actions: {
    submit(newCompany) {
      newCompany.save()
        .then(function() {
          //save all locations
          //newCompany.get('locations').then(locations => locations.save());
          /*
          newCompany.get('locations').toArray().forEach(function(location) {
            location.set('company', newCompany);
            location.save();
          });

          newCompany.get('employeeQuantities').toArray().forEach(function(employeeQuantity) {
            employeeQuantity.save();
          });
          */
        })
        .then(() => this.sendAction('submit', newCompany))
        .then(() => this.get('notify').success('Firma wurde erstellt'));

      newCompany.get('locations').toArray().forEach(function(location) {
        location.save();
      });
      newCompany.get('employeeQuantities').toArray().forEach(function(employeeQuantity) {
        employeeQuantity.save();
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
