import Component from "@ember/component";
import { inject as service } from "@ember/service";
import $ from "jquery";

export default Component.extend({
  router: service(),

  didRender() {
    const rated = this.get(
      "router.currentState.routerJsState.queryParams.rated"
    );
    if (rated == "true") {
      $("#memberSkillsetRated").addClass("active");
    } else {
      $("#memberSkillsetRated").removeClass("active");
    }
  }
});
