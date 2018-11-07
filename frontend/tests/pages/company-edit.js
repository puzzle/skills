import {
  create,
  visitable,
  fillable,
  clickable,
  //clickOnText,
  //hasClass,
  //collection,
  text
} from 'ember-cli-page-object';

export default create({
  visit: visitable('/companies/:company_id'),
  toggleEditFormButton: clickable('[data-test-company-edit-form-toggle]'),

  toggleEditForm() {
    this.toggleEditFormButton();

    return this.editForm;
  },

  editForm: {
    scope: '#profil-uebersicht',
    submit: clickable('#submit-button'),
    reset: clickable('.form-button--reset'),
    name: fillable('[name="company[name]"]'),
    web: fillable('[name="company[web]"]'),
    email: fillable('[name="company[email]"]'),
    phone: fillable('[name="company[phone]"]'),
    partnermanager: fillable('[name="company[partnermanager]"]'),
    contactPerson: fillable('[name="company[contactPerson]"]'),
    emailContactPerson: fillable('[name="company[emailContactPerson]"]'),
    phoneContactPerson: fillable('[name="company[phoneContactPerson]"]'),
    crm: fillable('[name="company[crm]"]'),
    level: fillable('[name="company[level]"]'),
  },

  profileData: {
    scope: '#profile-uebersicht-content-show',

    name: text('[data-test-company-name]'),
    web: text('[data-test-company-web]'),
    email: text('[data-test-company-email]'),
    phone: text('[data-test-company-phone]'),
    partnermanager: text('[data-test-company-partnermanager]'),
    contactPerson: text('[data-test-company-contactPerson]'),
    emailContactPerson: text('[data-test-company-emailContactPerson]'),
    phoneContactPerson: text('[data-test-company-phoneContactPerson]'),
    crm: text('[data-test-company-crm]'),
    level: text('[data-test-company-level]'),
    locations: text('[data-test-locations]'),
    employeeQuantity1Category: text('[data-test-employee-quantity-category]'),
    employeeQuantity1Quantity: text('[data-test-employee-quantity-quantity]'),
  },
/*
  competences: {
    scope: '#competence',

    list: collection({
      itemScope: 'ul > li',
      item: {
        text: text(),
      },
    }),

    toggleForm: clickable('#button-new-competences'),
    textarea: fillable('.competences-edit-input'),
    submit: clickable('.form-button--submit'),
  },
*/
});
