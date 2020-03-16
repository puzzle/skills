import Component from "@ember/component";
import { inject } from "@ember/service";
import { computed } from "@ember/object";
import { getOwner } from "@ember/application";

export default Component.extend({
  store: inject(),
  intl: inject(),

  didInsertElement() {
    //We need global jquery here because Bootstrap renders the modal outside of the component
    /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
    $("#people-skill-new-modal").on("hide.bs.modal", () => {
      this.abort();
    });
    /* eslint-enable no-global-jquery, no-undef, jquery-ember-run  */
  },

  actions: {
    abortNew() {
      /*this try catch is necessary because bootstrap modal does not work in acceptance tests,
      meaning, this would throw an error no matter if the actual feature works and the test
      would fail.*/
      /* eslint-disable no-undef  */
      try {
        $("#people-skill-new-modal").modal("hide");
      } catch (error) {
        Ember.Logger.warn(error.stack);
      }
      /* eslint-enable no-undef  */
    }
  }
});
