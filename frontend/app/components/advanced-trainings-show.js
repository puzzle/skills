import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import Component from "@glimmer/component";
import sortByYear from "../utils/sort-by-year";
import { tracked } from "@glimmer/tracking";
import { inject as service } from "@ember/service";

@classic
export default class AdvancedTrainingsShow extends Component {
  @service notify;

  @tracked
  advancedTrainingNew;

  @tracked
  person;

  constructor() {
    super(...arguments);
  }

  get sortedAdvancedTrainings() {
    return sortByYear(this.args.person.advancedTrainings);
  }

  get amountOfAdvancedTrainings() {
    return this.sortedAdvancedTrainings.length;
  }

  personChanged() {
    this.toggleAdvancedTrainingNew(false);
  }

  @action
  toggleAdvancedTrainingNew(triggerNew) {
    this.advancedTrainingNew = triggerNew;
    //this.notifyPropertyChange("amountOfAdvancedTrainings");
  }
}
