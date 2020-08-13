import classic from "ember-classic-decorator";
import { action, computed } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@glimmer/component";
import { isBlank } from "@ember/utils";

@classic
export default class PeopleSearch extends Component {
  @service store;

  @service router;

  @computed("router.currentRoute.parent.params.person_id")
  get selected() {
    const currentId = this.router.currentRoute.parent.params.person_id;
    return currentId ? this.store.peekRecord("person", currentId) : undefined;
  }

  @computed("this.args.people")
  get peopleToSelect() {
    return this.args.people.toArray().sort((a, b) => {
      if (a.get("name") < b.get("name")) return -1;
      if (a.get("name") > b.get("name")) return 1;
      return 0;
    });
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
    this.router.transitionTo("person", person.id);
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
