import RSVP from "rsvp";
import {
  create,
  visitable,
  fillable,
  clickable,
  text,
  collection
} from "ember-cli-page-object";

const { resolve } = RSVP;

export default create({
  newPersonPage: {
    visit: visitable("/people/new"),
    submit: clickable("#submit-button"),
    toggleNewFormButton: clickable("[data-test-person-new-form-toggle]"),
    toggleNationalitiesCheckbox: clickable("#toggle-nationalities-id"),

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
    submit: clickable('[type="submit"]'),
    name: fillable('[name="name"]'),
    email: fillable('[name="email"]'),
    shortname: fillable('[name="shortname"]'),
    title: fillable('[name="title"]'),
    location: fillable('[name="location"]'),
    rolePercent: fillable('[name="rolePercent"]')
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
  },

  competences: {
    toggleForm: clickable("[data-test-competences-edit-form-toggle]"),
    submit: clickable("#submit-button"),

    list: collection({
      itemScope: ".competence-entity",
      item: {
        text: text()
      }
    })
  },

  educations: {
    amountOf: text("#amount-of-educations"),
    toggleForm: clickable("#educations-content-show .zeile"),

    list: collection({
      itemScope: ".education-entity",
      item: {
        text: text()
      }
    }),

    submit: clickable("#submit-education-button"),
    delete: clickable("#delete-education-icon #deleteButton"),
    confirm: clickable("#delete-button")
  }
});
