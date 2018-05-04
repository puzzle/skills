import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { Promise } from 'rsvp'

export default Component.extend({
  store: service(),
  i18n: service(),
  router: service(),

  actions: {
    submit(changeset) {
      changeset.save()
        // TODO: This triggers a transition to the company detail page
        //       but we might have errors saving related data further down
        //       the promise chain, shouldn't we transition after everything
        //       is successfully saved?
        .then(() => this.sendAction('submit'))
        .then(() => this.get('notify').success('Firmenprofil wurde aktualisiert!'))
        .then(() =>
          Promise.all([
            ...changeset
              .get('locations')
              .filterBy('hasDirtyAttributes')
              .map(location => location.save()),
            ...changeset
              .get('employeeQuantities')
              .filterBy('hasDirtyAttributes')
              .map(employeeQuantity => employeeQuantity.save())
          ])
        )
        .catch(() => {
          let company = this.get('company');
          let errors = company.get('errors').slice(); // clone array as rollbackAttributes mutates
          company.rollbackAttributes();
          // TODO: We rolled back company attributes and show company field
          //       errors but the related data might still be in an
          //       invalid state. Maybe there is a better way to handle
          //       these validations/rollbacks in Ember these days?
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get('i18n').t(`company.${attribute}`)['string']
            changeset.pushErrors(attribute, message);
            this.get('notify').alert(`${translated_attribute} ${message}`, { closeAfter: 10000 });
          });
        });

    },

    deleteCompany(companyToDelete) {
      $('.modal-backdrop').remove();
      companyToDelete
        .destroyRecord()
        .then(() => this.get('router').transitionTo('companies'));
      // TODO: Handle error case, display simple notification?
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
