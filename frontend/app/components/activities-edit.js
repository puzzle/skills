import Component from "@glimmer/component";
import sortByYear from "../utils/sort-by-year";
import { inject as service } from "@ember/service";
import { on } from "@ember/object/evented";
import { EKMixin, keyUp } from "ember-keyboard";
import { observer } from "@ember/object";
import intl from "../initializers/intl";

export default Component.extend(EKMixin, {
  @service intl,

  constructor() {
    this.activateKeyboard();
  },

  willDestroyElement() {
    this._super(...arguments);
    if (!this.alreadyAborted) {
      this.abortEdit();
    }
  },

  personChanged() {
    this.abort();
    this.alreadyAborted = true;
  },

  get sortedActivities() {
    return sortByYear(this.args.person.activities);
  },

  activateKeyboard() {
    this.keyboardActivated = true;
  },

  abortActivities() {
    //on(keyUp("Escape"), function() {
    this.abortEdit();
  },

  actions: {
    notify() {
      let length = this.sortedActivities.length;
      setTimeout(() => {
        if (length > this.sortedActivities.length) {
          return this.notifyPropertyChange(this.sortedActivities);
        }
      }, 500);
    },
    submit(person) {
      person
        .save()
        .then(() =>
          Promise.all([
            ...person.activities.map(activity =>
              activity.get("hasDirtyAttributes") ? activity.save() : null
            )
          ])
        )
        .then(() => (this.alreadyAborted = true))
        .then(() => this.sendAction("submit"))
        .then(() => this.notify.success("Successfully saved!"))
        .then(() =>
          this.$("#activity")[0].scrollIntoView({ behavior: "smooth" })
        )

        .catch(() => {
          let activities = this.activities;
          activities.forEach(activity => {
            let errors = activity.errors.slice(); // clone array as rollbackAttributes mutates

            activity.rollbackAttributes();

            errors.forEach(({ attribute, message }) => {
              let translated_attribute = this.intl.t(`activity.${attribute}`);
              this.notify.alert(`${translated_attribute} ${message}`, {
                closeAfter: 10000
              });
            });
          });
        });
    },
    abort() {
      let activities = this.person.activities.toArray();
      activities.forEach(activity => {
        if (activity.get("hasDirtyAttributes")) {
          activity.rollbackAttributes();
        }
      });
      this.sendAction("activitiesEditing");
    },

    abortEdit() {
      this.abort();
      this.alreadyAborted = true;
      this.$("#activity")[0].scrollIntoView({ behavior: "smooth" });
    }
  }
});
