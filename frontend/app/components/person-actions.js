import { inject as service } from "@ember/service";
import Component from "@ember/component";
import { observer } from "@ember/object";
import $ from "jquery";

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

  didRender() {
    const currentURL = this.get("router.currentURL");
    if (currentURL.includes("skills")) {
      $("#peopleSkillsLink").addClass("active");
    } else {
      $("#peopleSkillsLink").removeClass("active");
    }
  },

  actions: {
    startExport(personId, e) {
      e.preventDefault();
      const currentURL = this.get("router.currentURL");
      url = currentURL.includes("skills")
        ? "people_skills.csv?person_id=" + this.get("person.id")
        : "people/" + this.get("person.id") + ".odt";

      let url = `/api/${url}`;
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
