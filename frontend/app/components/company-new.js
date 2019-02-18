import Component from '@ember/component';
import { inject as service } from '@ember/service';
import { Promise } from 'rsvp'

export default Component.extend({
  store: service(),
  i18n: service(),

  actions: {
    submit(newCompany) {
      return newCompany.save()
        .then(() =>
          Promise.all([
            ...newCompany
              .get('locations')
              .map(location => location.save()),
            ...newCompany
              .get('employeeQuantities')
              .map(employeeQuantity => employeeQuantity.save())
          ])
        )
        .then(() => this.sendAction('submit', newCompany))
        .then(() => this.get('notify').success('Firma wurde erstellt'))
        .catch(() => {
          let errors = newCompany.get('errors').slice();

          const locations = newCompany.get('locations');
          locations.forEach(location => {
            errors = errors.concat(location.get('errors').slice())
          });

          const employeeQuantities = newCompany.get('employeeQuantities');
          employeeQuantities.forEach(quantity => {
            errors = errors.concat(quantity.get('errors').slice())
          });

          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`company.${attribute}`)['string']
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 8000 });
          });
        });
    },

    addLocations(company) {
      this.get('store').createRecord('location', { company });
    },

    addEmployeeQuantity(company) {
      this.get('store').createRecord('employee-quantity', { company });
    },

    deleteLocation(location) {
      return location.destroyRecord();
    },

    deleteEmployeeQuantity(quantity) {
      return quantity.destroyRecord();
    }
  }
});
