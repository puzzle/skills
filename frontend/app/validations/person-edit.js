import { validatePresence } from "ember-changeset-validations/validators";

export default {
  name: [validatePresence(true)],
  email: [validatePresence(true)],
  title: [validatePresence(true)],
  birthdate: [validatePresence(true)],
  location: [validatePresence(true)]
};
