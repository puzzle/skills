import classic from "ember-classic-decorator";
import { observes } from "@ember-decorators/object";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";
import $ from "jquery";

@classic
export default class PersonActions extends Component {
  @service
  ajax;

  @service
  router;

  @service
  download;

  @service
  store;

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
    url = currentURL.includes("skills")
      ? "people_skills.csv?person_id=" + this.get("person.id")
      : "people/" + this.get("person.id") + ".odt";

    let url = `/api/${url}`;
    this.get("download").file(url);
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
