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
    submit: clickable('[type="submit"]'),
    name: fillable('[name="name"]'),
    email: fillable('[name="email"]'),
    title: fillable('[name="title"]'),
    location: fillable('[name="location"]'),
    rolePercent: fillable('[name="person[role-percent]"]')
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
    maritalStatus: text("#data-test-person-marital-status")
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
    delete: clickable("#deleteButton"),
    confirm: clickable("#delete-button")
  }
});
