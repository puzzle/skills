import Component from "@glimmer/component";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import { isBlank } from "@ember/utils";
import { tracked } from "@glimmer/tracking";
import PeopleSkill from "../models/people-skill";

export default class PersonCvExport extends Component {
  @service download;
  @service router;
  @service store;

  @tracked
  selectedLocation = "";

  @tracked
  levelValue = this.level || 1;

  @tracked
  availableLocations = "";

  constructor() {
    super(...arguments);

    this.includeCompetencesAndSkills = true;
    this.includeSkillsByLevel = false;

    this.store.findAll("branch-adress").then(result => {
      this.availableLocations = result;
      this.selectedLocation = result.filter(
        location => location.defaultBranchAdress
      ).firstObject;
    });
  }

  @action
  handleFocus(select, e) {
    if (this.focusComesFromOutside(e)) {
      select.actions.open();
    }
  }

  @action
  handleBlur() {}

  @action
  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains("ember-power-select-search-input");
  }

  @action
  setLocation(location) {
    this.selectedLocation = location;
  }

  get levelName() {
    return PeopleSkill.LEVEL_NAMES[this.levelValue];
  }

  @action
  startExport(e) {
    e.preventDefault();

    let url =
      "/api/people/" +
      this.args.person.id +
      ".odt?anon=false&location=" +
      this.selectedLocation.id +
      "&includeCS=" +
      this.includeCompetencesAndSkills +
      "&skillsByLevel=" +
      this.includeInterestValue();

    this.download.file(url);
  }
  includeInterestValue() {
    return this.includeSkillsByLevel
      ? "true&levelValue=" + this.levelValue
      : "false";
  }

  @action
  startAnonymizedExport(e) {
    e.preventDefault();

    let url =
      "/api/people/" +
      this.args.person.id +
      ".odt?anon=true&location=" +
      this.selectedLocation.id +
      "&includeCS=" +
      this.includeCompetencesAndSkills;
    this.download.file(url);
  }
}
