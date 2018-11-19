import {
  create,
  visitable,
  fillable,
  clickable,
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
