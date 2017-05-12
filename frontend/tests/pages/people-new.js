import {
  create,
  visitable,
  fillable,
  clickable
} from 'ember-cli-page-object';

export default create({
  visit: visitable('/people/new'),
  submit: clickable('#profil .form-button--submit'),
  name: fillable('[name="person[name]"]'),
  title: fillable('[name="person[title]"]'),
  role: fillable('[name="person[role]"]'),
  birthdate: fillable('#profil #date_location > input'),
  origin: fillable('[name="person[origin]"]'),
  location: fillable('[name="person[location]"]'),
  language: fillable('[name="person[language]"]'),
  maritalStatus: fillable('[name="person[martialStatus]"]'),
  status: fillable('[name="person[statusId]"]'),

  createPerson(person) {
    Object.keys(person).forEach(key =>
      this[key](person[key])
    );

    return this.submit();
  }
});
