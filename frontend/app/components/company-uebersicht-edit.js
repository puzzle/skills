import { inject as service } from '@ember/service';
import Component from '@ember/component';

export default Component.extend({
  store: service(),
  i18n: service(),
  router: service(),

  actions: {
    submit(changeset) {
      changeset.get('locations').toArray().forEach(function(location) {
        location.save();
      });
      changeset.get('employeeQuantities').toArray().forEach(function(employeeQuantity) {
        employeeQuantity.save();
      });
      return changeset.save()
        .then(() => this.sendAction('submit'))
        .then(() => this.get('notify').success('Firmenübersicht wurde aktualisiert!'))
        .catch(() => {
          let company = this.get('company');
          let errors = company.get('errors').slice(); // clone array as rollbackAttributes mutates
          company.rollbackAttributes();
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`company.${attribute}`)['string']
            changeset.pushErrors(attribute, message);
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });
    },

    deleteCompany(companyToDelete) {
      companyToDelete.destroyRecord();
      this.get('router').transitionTo('companies');
      setTimeout(function() {
        window.location.reload();
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
