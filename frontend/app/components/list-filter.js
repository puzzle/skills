import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";

@classic
export default class ListFilter extends Component {
  @service
  router;

  init() {
    super.init(...arguments);
    this.filterAction = this.get("filter");
    this.set(
      "value",
      this.get("router.currentState.routerJsState.queryParams.title")
    );
  }

  @action
  filterByName() {
    const param = this.get("value");

    if (param == "") {
      this.get("router").transitionTo({ queryParams: { title: null } });
    } else {
      this.get("router").transitionTo({ queryParams: { title: param } });
    }
  }
}
