import { create, visitable, clickable, text } from "ember-cli-page-object";

export default create({
  visit: visitable("/companies/:company_id"),
  toggleEditFormButton: clickable("[data-test-company-edit-form-toggle]"),
  deleteButton: clickable("#deleteButton"),

  pressDeleteButton() {
    this.deleteButton();

    return this.deleteConfirmation;
  },

  toggleEditForm() {
    this.toggleEditFormButton();

    return this.editForm;
  },

  editForm: {
    submit: clickable("#submit-button")
  },

  deleteConfirmation: {
    scope: "#delete-confirmation-modal",
    submit: clickable("#delete-button"),
    cancel: clickable("#cancel-button")
  },

  profileData: {
    scope: "#profile-uebersicht-content-show",
    name: text("[data-test-company-name]"),
    web: text("[data-test-company-web]"),
    email: text("[data-test-company-email]"),
    phone: text("[data-test-company-phone]"),
    partnermanager: text("[data-test-company-partnermanager]"),
    contactPerson: text("[data-test-company-contactPerson]"),
    emailContactPerson: text("[data-test-company-emailContactPerson]"),
    phoneContactPerson: text("[data-test-company-phoneContactPerson]"),
    crm: text("[data-test-company-crm]"),
    level: text("[data-test-company-level]"),
    locations: text("[data-test-locations]"),
    employeeQuantity1Category: text("[data-test-employee-quantity-category]"),
    employeeQuantity1Quantity: text("[data-test-employee-quantity-quantity]")
  }
});
