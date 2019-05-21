import { inject as service } from "@ember/service";
import Component from "@ember/component";

export default Component.extend({
  ajax: service(),
  router: service(),
  download: service(),

  actions: {
    startExport(personId, e) {
      e.preventDefault();
      const currentURL = this.get("router.currentURL");
      let format = currentURL.includes("skills") ? "csv" : "odt";
      let url = `/api/${currentURL}.${format}`;
      this.get("download").file(url);
    },

    exportDevFws(personId, e) {
      e.preventDefault();
      let url = `/api/people/${personId}/fws.odt?discipline=development`;
      this.get("download").file(url);
    },

    exportSysFws(personId, e) {
      e.preventDefault();
      let url = `/api/people/${personId}/fws.odt?discipline=system_engineering`;
      this.get("download").file(url);
    }
  }
});
