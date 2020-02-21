import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import Component from "@ember/component";
import $ from "jquery";

@classic
export default class NavSidebar extends Component {
  init() {
    super.init(...arguments);
    this.set("myStickyOptions", { topSpacing: 160 });
  }

  @action
  scrollTo(target) {
    const topOfElement = $(target)[0].offsetTop - 15;
    window.scroll({ top: topOfElement, behavior: "smooth" });
    return false;
  }
}
