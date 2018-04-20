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
        })
        .catch(() => {
          let company = this.get('newCompany');
          let errors = company.get('errors').slice();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`company.${attribute}`)['string']
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
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
    },

    deleteLocation(location) {
      location.destroyRecord();
    },

    deleteEmployeeQuantity(quantity) {
      quantity.destroyRecord();
    }
  }
});
