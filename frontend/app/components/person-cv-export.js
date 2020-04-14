import Component from "@glimmer/component";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";

export default class PersonCvExport extends Component {
  @service download;
  @service router;

  init() {
    super.init(...arguments);
  }

  @action
  startExport(e) {
    e.preventDefault();

    let url = `/api/people/` + this.args.person.id + ".odt?anon=false";
    this.download.file(url);
  }

  @action
  startAnonymizedExport(e) {
    e.preventDefault();
    let url = `/api/people/` + this.args.person.id + `.odt?anon=true`;
    this.download.file(url);
  }
}
