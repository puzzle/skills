import { run } from '@ember/runloop';
import $ from 'jquery';
import RSVP from 'rsvp';
import {
  create,
  visitable,
  fillable,
  selectable,
  clickable
} from 'ember-cli-page-object';

const { resolve } = RSVP;

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
  status: selectable('[name="person[statusId]"]'),
  company: fillable('[name="person[company]"]'),

  async createPerson(person) {
    await Object.keys(person)
      .reduce((p, key) => p.then(() => this[key](person[key])), resolve());

    run(() => {
      $('#profil #date_location > input')
        .datepicker('setDate', person.birthdate);
    });

    return this.submit();
  }
});
