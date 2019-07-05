import Component from "@ember/component";
import { inject as service } from "@ember/service";
import { computed } from "@ember/object";
import { isBlank } from "@ember/utils";

export default Component.extend({
  store: service(),
  router: service(),

  init() {
    this._super(...arguments);
  },

  selected: computed(
    "router.currentState.routerJsState.params.person.person_id",
    function() {
      const currentId = this.get(
        "router.currentState.routerJsState.params.person.person_id"
      );
      if (currentId) return this.get("store").find("person", currentId);
    }
  ),

  peopleToSelect: computed(function() {
    return this.get("store")
      .findAll("person", { reload: true })
      .then(people =>
        people.toArray().sort((a, b) => {
          if (a.get("name") < b.get("name")) return -1;
          if (a.get("name") > b.get("name")) return 1;
          return 0;
        })
      );
  }),

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains("ember-power-select-search-input");
  },

  actions: {
    changePerson(person) {
      this.set("selected", person);
      person.reload();
      this.get("router").transitionTo("person", person);
    },

    handleFocus(select, e) {
      if (this.focusComesFromOutside(e)) {
        select.actions.open();
      }
    },

    handleBlur() {}
  }
});
