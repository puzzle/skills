import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";

@classic
export default class ExportDocuments extends Component {
  @service
  download;

  @action
  exportEmptyDevFws() {
    let url = `/api/documents/templates/fws.odt?empty=true&discipline=development`;
    this.get("download").file(url);
  }

  @action
  exportEmptySysFws() {
    let url = `/api/documents/templates/fws.odt?empty=true&discipline=system_engineering`;
    this.get("download").file(url);
  }
}
