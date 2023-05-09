import RSVP from "rsvp";
import {
  clickable,
  create,
  fillable,
  text,
  visitable
} from "ember-cli-page-object";

const { resolve } = RSVP;

export default create({
  newPersonPage: {
    visit: visitable("/people/new"),
    submit: clickable("[data-test-peron-form-submit]"),
    toggleNewFormButton: clickable("[data-test-person-new-form-toggle]"),
    toggleNationalitiesCheckbox: clickable("#toggle-nationalities-id"),
    newRoleButton: clickable("[data-test-new-function]"),

    toggleNewForm() {
      return this.newForm;
    },

    async createPerson(person) {
      await Object.keys(person).reduce(
        (p, key) => p.then(() => this[key](person[key])),
        resolve()
      );

      return this.submit();
    }
  },

  newForm: {
    scope: "#profil",
    name: fillable('[id="name"]'),
    email: fillable('[id="email"]'),
    title: fillable('[id="degree"]'),
    location: fillable('[id="location"]'),
    rolePercent: fillable(".percent-field > label > input"),
    shortname: fillable('[id="shortname"]'),
    submit: clickable('[id="submit-button"]')
  },

  profileData: {
    name: text("#data-test-person-name"),
    email: text("#data-test-person-email"),
    title: text("#data-test-person-title"),
    role: text("#data-test-person-role"),
    department: text("#data-test-person-department"),
    company: text("#data-test-person-company"),
    birthdate: text("#data-test-person-birthdate"),
    nationalities: text("#data-test-person-nationalities"),
    location: text("#data-test-person-location"),
    language: text("[data-test-person-language]", { multiple: true }),
    maritalStatus: text("#data-test-person-marital-status"),
    shortname: text("#data-test-person-shortname")
  }
});
