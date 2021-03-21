import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Controller from "@ember/controller";
import ENV from "../config/environment";

@classic
export default class ApplicationController extends Controller {
  @service("keycloak-session")
  session;

  @service
  router;

  helplink = ENV.helplink;

  init() {
    super.init(...arguments);
    let session = this.session;
    let sessionInfo = session.get("tokenParsed");
    this.set(
      "username",
      sessionInfo.given_name + " " + sessionInfo.family_name
    );
    this.set("isAdmin", session.hasResourceRole("ADMIN"));
  }

  @action
  transitionToProfile() {
    let people = this.store.findAll("person");
    people.then(() => {
      let person = people.filterBy("name", this.username)[0];
      if (person == undefined) {
        this.router.transitionTo("people");
      } else {
        this.router.transitionTo("person", person.id);
      }
    });
  }

  @action
  logoutUser() {
    let session = this.session;
    session.logout();
  }
}
