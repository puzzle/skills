import classic from "ember-classic-decorator";
import { observes } from "@ember-decorators/object";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";
/* eslint-disable ember/new-module-imports  */
import Ember from "ember";
const { $ } = Ember;
/* eslint-enable ember/new-module-imports  */

@classic
export default class PersonActions extends Component {
  @service ajax;

  @service router;

  @service download;

  @service store;

  init() {
    super.init(...arguments);
    this.refreshUnratedSkillsAmount();
  }

  @observes("person.peopleSkills.@each.id")
  peopleSkillsChanged() {
    this.refreshUnratedSkillsAmount();
  }

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
  }

  didRender() {
    const currentURL = this.get("router.currentURL");
    if (currentURL.includes("skills")) {
      $("#peopleSkillsLink").addClass("active");
    } else {
      $("#peopleSkillsLink").removeClass("active");
    }
  }

  @action
  startExport(personId, e) {
    e.preventDefault();
    const currentURL = this.get("router.currentURL");

    if (currentURL.includes("skills")) {
      let url = "/api/people_skills.csv?person_id=" + this.get("person.id");
      this.get("download").file(url);
    } else {
      $("#person-cv-export").modal("toggle");
    }
  }

  @action
  exportDevFws(personId, e) {
    e.preventDefault();
    let url = `/api/people/${personId}/fws.odt?discipline=development`;
    this.get("download").file(url);
  }

  @action
  exportSysFws(personId, e) {
    e.preventDefault();
    let url = `/api/people/${personId}/fws.odt?discipline=system_engineering`;
    this.get("download").file(url);
  }
}
