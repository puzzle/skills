import { isEmpty } from "@ember/utils";
import { inject as service } from "@ember/service";
import RSVP, { resolve } from "rsvp";

const { Promise } = RSVP;

export default Base.extend({
  ajax: service(),
  session: service("keycloak-session"),

  restore(data) {
    if (isEmpty(data.token)) {
      return Promise.reject(new Error("No Token to restore found"));
    }
    return Promise.resolve(data);
  },

  invalidate(data) {
    return resolve();
  }
});
