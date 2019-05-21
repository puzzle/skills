import { inject as service } from "@ember/service";
import Component from "@ember/component";

export default Component.extend({
  router: service(),

  actions: {
    deletePerson(personToDelete) {
      personToDelete.destroyRecord();
      this.get("router").transitionTo("people");
    }
  }
});
