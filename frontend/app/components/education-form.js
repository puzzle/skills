import Component from "@glimmer/component";
import { inject as service } from "@ember/service";
import { addObserver } from "@ember/object/observers";

export default class EducationForm extends Component {
  @service intl;
  @service store;

  constructor() {
    super(...arguments);
    this.person = this.args.person;
    addObserver(this, "person", this.personChanged);
  }
}
