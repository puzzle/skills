import Component from "@ember/component";
import { inject } from "@ember/service";

export default Component.extend({
  store: inject(),
  intl: inject(),

  init() {
    this._super(...arguments);
  },

  didInsertElement() {
    //We need global jquery here because Bootstrap renders the modal outside of the component
    /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
    $("#person-cv-export").on("hide.bs.modal", () => {
      //this.abort();
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
        $("#person-cv-export").modal("hide");
      } catch (error) {
        Ember.Logger.warn(error.stack);
      }
      /* eslint-enable no-undef  */
    }
  }
});
