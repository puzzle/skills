import Component from "@ember/component";
import sortByYear from "../utils/deprecated-sort-by-year";
import { inject as service } from "@ember/service";
import { on } from "@ember/object/evented";
import { EKMixin, keyUp } from "ember-keyboard";
import { observer } from "@ember/object";

export default Component.extend(EKMixin, {
  willDestroyElement() {
    this._super(...arguments);
    if (!this.alreadyAborted) this.send("abortEdit");
  },

  personChanged: observer("person", function() {
    this.send("abort");
    this.set("alreadyAborted", true);
  }),

  intl: service(),

  sortedActivities: sortByYear("activities"),

  activateKeyboard: on("init", function() {
    this.set("keyboardActivated", true);
  }),

  abortActivities: on(keyUp("Escape"), function() {
    this.send("abortEdit");
  }),

  actions: {
    notify() {
      let length = this.sortedActivities.length;
      setTimeout(() => {
        if (length > this.sortedActivities.length) {
          return this.notifyPropertyChange("sortedActivities");
        }
      }, 500);
    },
    submit(person) {
      person
        .save()
        .then(() =>
          Promise.all([
            ...person
              .get("activities")
              .map(activity =>
                activity.get("hasDirtyAttributes") ? activity.save() : null
              )
          ])
        )
        .then(() => this.set("alreadyAborted", true))
        .then(() => this.sendAction("submit"))
        .then(() => this.notify.success("Successfully saved!"))
        .then(() =>
          this.$("#activity")[0].scrollIntoView({ behavior: "smooth" })
        )

        .catch(() => {
          let activities = this.activities;
          activities.forEach(activity => {
            let errors = activity.get("errors").slice(); // clone array as rollbackAttributes mutates

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
      let activities = this.get("person.activities").toArray();
      activities.forEach(activity => {
        if (activity.get("hasDirtyAttributes")) {
          activity.rollbackAttributes();
        }
      });
      this.sendAction("activitiesEditing");
    },

    abortEdit() {
      this.send("abort");
      this.set("alreadyAborted", true);
      this.$("#activity")[0].scrollIntoView({ behavior: "smooth" });
    }
  }
});
