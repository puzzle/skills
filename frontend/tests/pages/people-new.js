import RSVP from 'rsvp';
import {
  create,
  visitable,
  fillable,
  clickable,
  text
} from 'ember-cli-page-object';

const { resolve } = RSVP;

export default create({
  newPersonPage: {
    visit: visitable('/people/new'),
    submit: clickable('#submit-button'),

    name: fillable('[name="person[name]"]'),
    title: fillable('[name="person[title]"]'),
    location: fillable('[name="person[location]"]'),

    createPerson(person) {
      Object.keys(person)
        .reduce((p, key) => p.then(() => this[key](person[key])), resolve());

      return this.submit();
    },
  },

  profileData: {
    name: text('#data-test-person-name'),
    title: text('#data-test-person-title'),
    role: text('#data-test-person-role'),
    birthdate: text('#data-test-person-birthdate'),
    nationalities: text('#data-test-person-nationalities'),
    location: text('#data-test-person-location'),
    language: text('[data-test-person-language]', { multiple: true }),
    maritalStatus: text('#data-test-person-marital-status'),
  },
});
