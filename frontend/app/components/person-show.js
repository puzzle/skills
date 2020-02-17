import classic from "ember-classic-decorator";
import { action, computed } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";
import sortByLanguage from "../utils/sort-by-language";
import Person from "../models/person";

@classic
export default class PersonShow extends Component {
  @service
  ajax;

  @service
  router;

  @service
  download;

  @service("keycloak-session")
  session;

  @computed("person.picturePath")
  get picturePath() {
    if (this.get("person.picturePath")) {
      let path =
        this.get("person.picturePath") +
        "&authorizationToken=" +
        this.get("session.token");
      return path;
    }
    return "";
  }

  @sortByLanguage("person.languageSkills")
  sortedLanguageSkills;

  @computed("person.maritalStatus")
  get maritalStatus() {
    const maritalStatuses = Person.MARITAL_STATUSES;
    const key = this.get("person.maritalStatus");
    return maritalStatuses[key];
  }

  @action
  exportCvOdt(personId, e) {
    e.preventDefault();
    let url = `/api/people/${personId}.odt`;
    this.get("download").file(url);
  }
}
