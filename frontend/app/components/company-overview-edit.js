import { inject as service } from "@ember/service";
import Component from "@ember/component";
import $ from "jquery";
import { isBlank } from "@ember/utils";

export default Component.extend({
  store: service(),
  i18n: service(),
  router: service(),

  removeEmptyElements(...records) {
    let errors = [];
    records.forEach(record => {
      record[0].forEach(element => {
        record[1].forEach(attr => {
          if (isBlank(element.get(attr))) {
            let attribute = this.get("i18n").t(`company.${attr}`)["string"];
            errors.addObject(
              attribute + " Feld ist leer, der Eintrag wurde nicht gespeichert"
            );
            if (!element.get("isDeleted")) element.destroyRecord();
          }
        });
      });
    });
    return errors;
  },

  actions: {
    submit(changeset) {
      let locations = this.get("company.locations").toArray();
      let employeeQuantities = this.get("company.employeeQuantities").toArray();
      let errors = this.removeEmptyElements(
        [locations, ["location"]],
        [employeeQuantities, ["category", "quantity"]]
      );
      errors.forEach(error => {
        this.get("notify").alert(error, { closeAfter: 5000 });
      });

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

    deleteCompany(companyToDelete) {
      $(".modal-backdrop").remove();
      companyToDelete
        .destroyRecord()
        .then(() => this.get("router").transitionTo("companies"));
      // TODO: Handle error case, display simple notification?
    },

    addLocations(company) {
      this.get("store").createRecord("location", { company });
    },

    addEmployeeQuantity(company) {
      this.get("store").createRecord("employee-quantity", { company });
    },

    deleteLocation(location) {
      return location.destroyRecord();
    },

    deleteEmployeeQuantity(quantity) {
      return quantity.destroyRecord();
    }
  }
});
