import Component from "@glimmer/component";
import { inject as service } from "@ember/service";
import classic from "ember-classic-decorator";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import sortByYear from "../utils/sort-by-year";

@classic
export default class AdvancedTrainingsShow extends Component {
  @service notify;

  @tracked
  isNewRecord = false;

  @tracked
  editingAdvancedTraining;

  frozenSortedAdvancedTraining;

  constructor() {
    super(...arguments);
    // addObserver(this, "person", this.personChanged);
    // this is a hack because ember keyboard is not ported to octane yet.
    // normal jquery events using the {{on}} template helper doesn't work for escape key
  }

  get sortedAdvancedTrainings() {
    return !this.editingAdvancedTraining
      ? sortByYear(this.args.advancedTrainings)
      : this.frozenSortedAdvancedTraining;
  }

  get amountOfAdvancedTrainings() {
    return this.sortedAdvancedTrainings.length;
  }

  @action
  toggleAdvancedTrainingNew() {
    this.isNewRecord = !this.isNewRecord;
  }

  @action
  setEditingAdvancedTraining(advancedTraining) {
    this.frozenSortedAdvancedTraining = this.sortedAdvancedTrainings;
    this.editingAdvancedTraining =
      this.editingAdvancedTraining || advancedTraining;
  }

  @action
  abortAdvancedTrainingEdit() {
    this.editingAdvancedTraining = null;
  }
}
