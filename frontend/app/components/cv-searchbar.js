import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";

@classic
export default class CvSearchbar extends Component {
  @service router;

  didReceiveAttrs() {
    this.value = this.router.currentRoute.queryParams.q;
  }

  @action
  searchThroughCVs() {
    const param = this.value;

    if (param == "") {
      this.router.transitionTo({ queryParams: { q: null } });
    } else {
      this.router.transitionTo({ queryParams: { q: param } });
    }
  }

  @action
  clearValue() {
    this.set("value", "");
    this.send("searchThroughCVs");
  }
}
