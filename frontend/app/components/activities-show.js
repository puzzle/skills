import Component from "@glimmer/component";
import { inject as service } from "@ember/service";
import classic from "ember-classic-decorator";
import { tracked } from "@glimmer/tracking";
import { action } from "@ember/object";
import sortByYear from "../utils/sort-by-year";

@classic
export default class ActivitiesShow extends Component {
  @service notify;

  @tracked
  isNewRecord = false;

  @tracked
  editingActivity;

  frozenSortedActivity;

  constructor() {
    super(...arguments);
    // addObserver(this, "person", this.personChanged);
    // this is a hack because ember keyboard is not ported to octane yet.
    // normal jquery events using the {{on}} template helper doesn't work for escape key
  }

  get sortedActivities() {
    return !this.editingActivity
      ? sortByYear(this.args.activities)
      : this.frozenSortedActivity;
  }

  get amountOfActivities() {
    return this.sortedActivities.length;
  }

  @action
  toggleActivityNew() {
    this.isNewRecord = !this.isNewRecord;
  }

  @action
  setEditingActivity(activity) {
    this.frozenSortedActivity = this.sortedActivities;
    this.editingActivity = this.editingActivity || activity;
  }

  @action
  abortActivityEdit() {
    this.editingActivity = null;
  }
}
