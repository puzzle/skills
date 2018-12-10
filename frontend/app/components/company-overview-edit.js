import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { on } from '@ember/object/evented';
import { EKMixin , keyUp } from 'ember-keyboard';

export default Component.extend(EKMixin, {
  store: service(),
  i18n: service(),
  router: service(),

  rejectBlankRelationships() {
    this.rejectBlankEntries("locations", "location");
    this.rejectBlankEntries("employeeQuantities", "category");
  },

  rejectBlankEntries(relationshipName, attrName) {
    let company = this.get("company");
    let records = company.get(relationshipName).toArray();
    records = records.filter(record => {
      let value = record.get(attrName);
      return Boolean(value) && value != "";
    });
    company.set(relationshipName, records);
  },

  activateKeyboard: on('init', function() {
    this.set('keyboardActivated', true);
  }),

  abortEducations: on(keyUp('Escape'), function() {
    let company = this.get('company')
    if (company.get('hasDirtyAttributes$')) {
      company.rollbackAttributes()
    }
    let locations = this.get("company.locations").toArray();
    let employeeQuantities = this.get("company.employeeQuantities").toArray();

    locations.forEach(location => {
      if (location.get("isNew")) {
        location.destroyRecord();
      }
      if (location.get('hasDirtyAttributes')) {
        location.rollbackAttributes();
      }
    });
    employeeQuantities.forEach(quantity => {
      if (quantity.get("isNew")) {
        quantity.destroyRecord();
      }
      if (quantity.get('hasDirtyAttributes')) {
        quantity.rollbackAttributes();
      }
    });
    this.sendAction("companyEditing");
  }),

  actions: {
    submit(changeset) {
      this.rejectBlankRelationships();

      changeset
        .save()
        // TODO: This triggers a transition to the company detail page
        //       but we might have errors saving related data further down
        //       the promise chain, shouldn't we transition after everything
        //       is successfully saved?
        .then(() => this.sendAction("submit"))
        .then(() =>
          this.get("notify").success("Firmenprofil wurde aktualisiert!")
        )
        .then(() =>
          Promise.all([
            ...changeset
              .get("locations")
              .filterBy("hasDirtyAttributes")
              .map(location => location.save()),
            ...changeset
              .get("employeeQuantities")
              .filterBy("hasDirtyAttributes")
              .map(employeeQuantity => employeeQuantity.save())
          ])
        )
        .catch(() => {
          let company = this.get("company");
          let errors = company.get("errors").slice(); // clone array as rollbackAttributes mutates
          company.rollbackAttributes();
          // TODO: We rolled back company attributes and show company field
          //       errors but the related data might still be in an
          //       invalid state. Maybe there is a better way to handle
          //       these validations/rollbacks in Ember these days?
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get("i18n").t(
              `company.${attribute}`
            )["string"];
            changeset.pushErrors(attribute, message);
            this.get("notify").alert(`${translated_attribute} ${message}`, {
              closeAfter: 10000
            });
          });
        });
    },

    abortEdit() {
      let locations = this.get("company.locations").toArray();
      let employeeQuantities = this.get("company.employeeQuantities").toArray();

      locations.forEach(location => {
        if (location.get("isNew")) {
          location.destroyRecord();
        }
      });
      employeeQuantities.forEach(quantity => {
        if (quantity.get("isNew")) {
          quantity.destroyRecord();
        }
      });
      this.sendAction("companyEditing");
    },

    addLocations(company) {
      this.get("store").createRecord("location", { company });
    },

    addEmployeeQuantity(company) {
      this.get('store').createRecord('employee-quantity', { company });
    }
  }
});
