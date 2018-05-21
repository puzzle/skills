/* global clickDropdown */
import {
  create,
  visitable,
  fillable,
  clickable,
  clickOnText,
  hasClass,
  collection,
  text
} from 'ember-cli-page-object';

export default create({
  visit: visitable('/people/:person_id'),
  toggleEditFormButton: clickable('[data-test-person-edit-form-toggle]'),

  toggleEditForm() {
    this.toggleEditFormButton();

    return this.editForm;
  },

  editForm: {
    scope: '#profil',
    submit: clickable('#submit-button'),
    name: fillable('[name="person[name]"]'),
    title: fillable('[name="person[title]"]'),
    role: fillable('[name="person[role]"]'),
    birthdate: fillable('#date_location > input'),
    origin: fillable('[name="person[origin]"]'),
    location: fillable('[name="person[location]"]'),
    language: fillable('[name="person[language]"]'),
    maritalStatus: fillable('[name="person[martialStatus]"]'),
  },

  profileData: {
    scope: '#profile-content-show',

    name: text('[data-test-person-name]'),
    title: text('[data-test-person-title]'),
    role: text('[data-test-person-role]'),
    birthdate: text('[data-test-person-birthdate]'),
    origin: text('[data-test-person-origin]'),
    location: text('[data-test-person-location]'),
    language: text('[data-test-person-language]'),
    maritalStatus: text('[data-test-person-marital-status]'),
  },

  personActions: {
    scope: '.toolbar-pills',

    openVariationDropdown() {
      return clickDropdown('#variation-cv-pill > .ember-basic-dropdown-trigger');
    },

    originCVIsActive: hasClass('active', '#actual-cv-pill > a'),

    variationDropdownButtonText:
      text('#variation-cv-pill > .ember-basic-dropdown-trigger'),

    variationDropdownButtonIsActive: hasClass('active', '#variation-cv-pill'),
  },

  variationDropdown: {
    scope: '[data-test-variation-dropdown-content]',

    newVariation: clickable('.new-variation-link'),
  },

  createVariationDialog: {
    scope: '[data-test-variation-modal]',

    variationName: fillable('[name="person[variationName]"]'),
    cancel: clickOnText('Abbrechen'),
    create: clickable('.btn-primary'),
  },

  async createVariation(name) {
    await this.personActions.openVariationDropdown();
    await this.variationDropdown.newVariation();
    await this.createVariationDialog.variationName(name);
    return this.createVariationDialog.create();
  },

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
});
