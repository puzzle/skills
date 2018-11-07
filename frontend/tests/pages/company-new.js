import RSVP from "rsvp";
import { create, visitable, fillable, clickable } from "ember-cli-page-object";

const { resolve } = RSVP;

export default create({
  visit: visitable("/companies/new"),
  submit: clickable("#profil #submit-button"),
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

  async createCompany(company) {
    await Object.keys(company).reduce(
      (p, key) => p.then(() => this[key](company[key])),
      resolve()
    );

    return this.submit();
  }
});
