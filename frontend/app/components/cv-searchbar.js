import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";
import { getCookie } from "../helpers/get-cookie";

@classic
export default class CvSearchbar extends Component {
  @service router;

  didReceiveAttrs() {
    let cookieValue = getCookie();
    if (cookieValue !== "undefined" && cookieValue !== undefined) {
      this.value = cookieValue;
    }
  }

  @action
  searchThroughCVs() {
    const param = this.get("value");
    document.cookie = "cv_search_query=" + param;

    if (param == "") {
      this.get("router").transitionTo({ queryParams: { q: null } });
    } else {
      this.get("router").transitionTo({ queryParams: { q: param } });
    }
  }

  @action
  clearValue() {
    this.set("value", "");
    this.send("searchThroughCVs");
  }
}
