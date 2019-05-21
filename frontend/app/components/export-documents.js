import { inject as service } from "@ember/service";
import Component from "@ember/component";

export default Component.extend({
  download: service(),

  actions: {
    exportEmptyDevFws() {
      let url = `/api/documents/templates/fws.odt?empty=true&discipline=development`;
      this.get("download").file(url);
    },

    exportEmptySysFws() {
      let url = `/api/documents/templates/fws.odt?empty=true&discipline=system_engineering`;
      this.get("download").file(url);
    }
  }
});
