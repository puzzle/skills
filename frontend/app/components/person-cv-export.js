import Component from "@glimmer/component";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import { isBlank } from "@ember/utils";

export default class PersonCvExport extends Component {
  @service download;
  @service router;

  locations = ["Zürich", "Basel", "Tübingen"];

  location = "";

  init() {
    super.init(...arguments);
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
    Ember.set(this, "location", location);
  }

  @action
  startExport(e) {
    e.preventDefault();

    let url =
      `/api/people/` +
      this.args.person.id +
      ".odt?anon=false&location=" +
      this.location;
    this.download.file(url);
  }

  @action
  startAnonymizedExport(e) {
    e.preventDefault();

    let url =
      "/api/people/" +
      this.args.person.id +
      ".odt?anon=true&location=" +
      this.location;
    this.download.file(url);
  }
}
