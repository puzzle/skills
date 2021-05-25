import classic from "ember-classic-decorator";
import { action } from "@ember/object";
import Component from "@glimmer/component";
import sortByYear from "../utils/sort-by-year";
import { tracked } from "@glimmer/tracking";
import { inject as service } from "@ember/service";

@classic
export default class ActivitiesShow extends Component {
  @service notify;

  @tracked
  activityNew;

  @tracked
  person;

  constructor() {
    super(...arguments);
  }

  get sortedActivities() {
    return sortByYear(this.args.person.activities);
  }

  get amountOfActivities() {
    return this.sortedActivities.length;
  }

  personChanged() {
    this.toggleActivityNew(false);
  }

  @action
  toggleActivityNew(triggerNew) {
    this.activityNew = triggerNew;
    this.notifyPropertyChange(this.amountOfActivities);
  }
}
