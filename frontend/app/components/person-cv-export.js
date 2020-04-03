import Component from "@ember/component";
import { inject } from "@ember/service";

export default Component.extend({
  download: inject(),
  router: inject(),

  init() {
    this._super(...arguments);
  },

  actions: {
    startExport(personId, e) {
      e.preventDefault();

      let url =
        `/api/people/` +
        this.get("router.currentURL").split("/")[2] +
        `.odt?anon=false`; //TODO: This is ugly
      this.get("download").file(url);
    },

    startAnonymizedExport(personId, e) {
      e.preventDefault();
      let url =
        `/api/people/` +
        this.get("router.currentURL").split("/")[2] +
        `.odt?anon=true`; //TODO: This is ugly
      this.get("download").file(url);
    }
  }
});
