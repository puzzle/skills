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
      console.log(personId);
      let url = `/api/people/` + personId + `.odt?anon=false`;
      this.get("download").file(url);
    },

    startAnonymizedExport(personId, e) {
      e.preventDefault();
      let url = `/api/people/` + personId + `.odt?anon=true`;
      this.get("download").file(url);
    }
  }
});
