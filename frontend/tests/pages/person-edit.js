import {
  create,
  visitable,
  fillable,
  clickable,
  triggerable,
  text
} from 'ember-cli-page-object';

export default create({
  visit: visitable('/people/:person_id'),
  toggleEditForm: clickable('[data-test-person-edit-form-toggle]'),

  editForm: {
    scope: '#profil',
    submit: clickable('.form-button--submit'),
    reset: clickable('.form-button--reset'),
    name: fillable('[name="person[name]"]'),
    title: fillable('[name="person[title]"]'),
    role: fillable('[name="person[role]"]'),
    birthdate: fillable('#date_location > input'),
    origin: fillable('[name="person[origin]"]'),
    location: fillable('[name="person[location]"]'),
    language: fillable('[name="person[language]"]'),
    maritalStatus: fillable('[name="person[martialStatus]"]'),
    status: fillable('[name="person[statusId]"]')
  },

  profileData: {
    scope: '#profile-content-show',

    name: text('[data-test-person-name]'),
    title: text('[data-test-person-title]'),
    role: text('[data-test-person-role]'),
    birthdate: text('[data-test-person-birthdate]'),
    origin: text('[data-test-person-origin]'),
    location: text('[data-test-person-location]'),
    maritalStatus: text('[data-test-person-marital-status]'),
    status: text('[data-test-person-status]')
  }
});
