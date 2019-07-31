import Service from "@ember/service";

export default Service.extend({
  tokenParsed: "1234",
  keycloak: Object.freeze([{ token: "1234" }]),

  hasResourceRole(resource, role) {
    return resource === "ADMIN";
  },

  installKeycloak(parameters) {},

  initKeycloak() {},

  checkTransition(transition) {},

  updateToken() {
    return new Promise((resolve, reject) => {
      resolve();
    });
  }
});
