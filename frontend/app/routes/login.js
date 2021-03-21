import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Route from "@ember/routing/route";
import UnauthenticatedRouteMixin from "ember-simple-auth/mixins/unauthenticated-route-mixin";

@classic
export default class LoginRoute extends Route.extend(
  UnauthenticatedRouteMixin
) {
  @service
  session;

  @action
  authenticate() {
    let password = this.controller.get("password");
    let identification = this.controller.get("identification");

    this.session
      .authenticate("authenticator:auth", password, identification)
      .then(() => {
        let full_username = this.get("session.data.authenticated.full_name");
        this.send("findAndTransitionToUser", full_username);
      })
      .catch(reason => {
        this.notify.alert((reason && reason.error) || "Unbekannter Fehler");
      });
  }

  @action
  findAndTransitionToUser(userName) {
    let people = this.store.findAll("person");
    people.then(() => {
      let person = people.filterBy("name", userName)[0];
      if (person == undefined) {
        this.transitionTo("people");
      } else {
        this.transitionTo("person", person.id);
      }
    });
  }
}
