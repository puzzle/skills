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
    location: fillable('[name="person[location]"]'),
  },

  profileData: {
    name: text('#data-test-person-name'),
    title: text('#data-test-person-title'),
    role: text('#data-test-person-role'),
    birthdate: text('#data-test-person-birthdate'),
    nationality: text('#data-test-person-nationality'),
    nationality2: text('#data-test-person-nationality2'),
    location: text('#data-test-person-location'),
    language: text('#data-test-person-language'),
    maritalStatus: text('#data-test-person-marital-status'),
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
    toggleForm: clickable('[data-test-company-edit-form-toggle]'),

    list: collection({
      itemScope: '.old-competence-list-entity',
      item: {
        text: text(),
      },
    }),

    textarea: fillable('.competences-edit-input'),
    submit: clickable('#submit-button'),
  },
});
