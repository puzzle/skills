import classic from "ember-classic-decorator";
import { action, computed } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";
import { isBlank } from "@ember/utils";

@classic
export default class PeopleSearch extends Component {
  @service
  store;

  @service
  router;

  init() {
    super.init(...arguments);
  }

  @computed("router.currentRoute.parent.params.person_id")
  get selected() {
    const currentId = this.get("router.currentRoute.parent.params.person_id");
    return currentId ? this.get("store").find("person", currentId) : undefined;
  }

  @computed
  get peopleToSelect() {
    return this.get("store")
      .findAll("person", { reload: true })
      .then(people =>
        people.toArray().sort((a, b) => {
          if (a.get("name") < b.get("name")) return -1;
          if (a.get("name") > b.get("name")) return 1;
          return 0;
        })
      );
  }

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains("ember-power-select-search-input");
  }

  @action
  changePerson(person) {
    this.set("selected", person);
    person.reload();
    this.get("router").transitionTo("person", person.id);
  }

  @action
  handleFocus(select, e) {
    if (this.focusComesFromOutside(e)) {
      select.actions.open();
    }
  }

  @action
  handleBlur() {}
}
