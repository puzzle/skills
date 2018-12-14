import RSVP from 'rsvp';
import {
  create,
  visitable,
  fillable,
  clickable
} from 'ember-cli-page-object';

const { resolve } = RSVP;

export default create({
  visit: visitable('/people/new'),
  submit: clickable('#profil #submit-button'),
  name: fillable('[name="person[name]"]'),
  title: fillable('[name="person[title]"]'),
  location: fillable('[name="person[location]"]'),

  async createPerson(person) {
    await Object.keys(person)
      .reduce((p, key) => p.then(() => this[key](person[key])), resolve());

    return this.submit();
  }
});
