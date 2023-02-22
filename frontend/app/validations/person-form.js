import {
  validatePresence,
  validateFormat
} from "ember-changeset-validations/validators";
export default {
  name: [validatePresence(true)],
  email: [
    validatePresence(true),
    validateFormat({
      type: "email",
      message: "Gib eine gültige Email Adresse ein"
    })
  ],
  title: [validatePresence(true)],
  birthdate: [validatePresence(true)],
  location: [validatePresence(true)]
};
