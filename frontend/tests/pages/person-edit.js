import {
  create,
  visitable,
  fillable,
  clickable,
  collection,
  text
} from "ember-cli-page-object";

export default create({
  visit: visitable("/people/:person_id"),
  toggleEditFormButton: clickable("[data-test-person-edit-form-toggle]"),
  toggleNationalitiesCheckbox: clickable("#toggle-nationalities-id"),

  toggleEditForm() {
    this.toggleEditFormButton();

    return this.editForm;
  },

  toggleNationalities() {
    this.toggleNationalitiesCheckbox();
    return this.editForm;
  },

  editForm: {
    scope: "#profil",
    name: fillable('[id="name"]'),
    email: fillable('[id="email"]'),
    title: fillable('[id="degree"]'),
    location: fillable('[id="location"]'),
    rolePercent: fillable('[id="rolePercent"]'),
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
    toggleForm: clickable("#educations-content-show .line"),

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
