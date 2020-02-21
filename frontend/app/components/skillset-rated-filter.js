import classic from "ember-classic-decorator";
import { inject as service } from "@ember/service";
import Component from "@ember/component";
import $ from "jquery";

@classic
export default class SkillsetRatedFilter extends Component {
  @service router;

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
}
