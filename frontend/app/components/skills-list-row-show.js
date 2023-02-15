import classic from "ember-classic-decorator";
import { tagName } from "@ember-decorators/component";
import Component from "@ember/component";
import { inject as service } from "@ember/service";

@classic
@tagName("tr")
export default class SkillsListRowShow extends Component {
  @service("keycloak-session")
  session;
  init() {
    super.init(...arguments);
    let session = this.get("session");
    this.set("isAdmin", session.hasResourceRole("ADMIN"));
  }
  click() {
    this.sendAction("toggleSkill", this.get("skill"));
  }
}
