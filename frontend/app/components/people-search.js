import Component from "@ember/component";
import { inject as service } from "@ember/service";
import { computed } from "@ember/object";
import { isBlank } from "@ember/utils";
import { action } from "@ember/object";

export default class PeopleSearchComponent extends Component {
  @service store;
  @service router;

  get selected() {
    const currentId = this.get(
      "router.currentState.routerJsState.params.person.person_id"
    );
    if (currentId) return this.get("store").find("person", currentId);
  }

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
    this.get("router").transitionTo("person", person);
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
