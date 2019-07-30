/*global Keycloak*/
import Application from "@ember/application";
import Service from "@ember/service";

export default Service.extend({
  token: "1234",

  init() {
    this._super(...arguments);
    this.set("tokenParsed", { given_name: "Tyrion", family_name: "Lannister" });
  },

  hasResourceRole(resource, role) {
    return resource === "ADMIN";
  },

  invalidate() {
    return true;
  },

  installKeycloak(parameters) {
    let keycloak = new Keycloak(parameters);
    Application.keycloak = keycloak;
    this.set("keycloak", keycloak);
  },

  initKeycloak() {
    return new Promise((resolve, reject) => {
      resolve(true);
    });
  },

  checkTransition(transition) {},

  updateToken() {
    return new Promise((resolve, reject) => {
      resolve();
    });
  },

  logout() {}
});
