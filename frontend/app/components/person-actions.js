import { inject as service } from "@ember/service";
import Component from "@ember/component";
import { observer } from "@ember/object";

export default Component.extend({
  ajax: service(),
  router: service(),
  download: service(),
  store: service(),

  init() {
    this._super(...arguments);
    this.refreshUnratedSkillsAmount();
  },

  peopleSkillsChanged: observer("person.peopleSkills.@each.id", function() {
    this.refreshUnratedSkillsAmount();
  }),

  refreshUnratedSkillsAmount() {
    this.get("ajax")
      .request("/skills/unrated_by_person", {
        data: {
          person_id: this.get("person.id")
        }
      })
      .then(response => {
        this.set("unratedSkillsAmount", response.data.length);
      });
  },

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
