import { inject as service } from "@ember/service";
import Component from "@ember/component";
import sortByYear from "../utils/sort-by-year";
import { on } from "@ember/object/evented";
import { EKMixin, keyUp } from "ember-keyboard";
import { observer } from "@ember/object";

export default Component.extend(EKMixin, {
  willDestroyElement() {
    this._super(...arguments);
    if (!this.get("alreadyAborted")) this.send("abortEdit");
  },

  personChanged: observer("person", function() {
    this.send("abort");
    this.set("alreadyAborted", true);
  }),

  intl: service(),

  activateKeyboard: on("init", function() {
    this.set("keyboardActivated", true);
    this.sortedAdvancedTrainings = sortByYear("advanced-trainings").volatile();
  }),

  abortAdvancedTrainings: on(keyUp("Escape"), function() {
    this.send("abortEdit");
  }),

  actions: {
    notify() {
      let length = this.get("sortedAdvancedTrainings").length;
      setTimeout(() => {
        if (length > this.get("sortedAdvancedTrainings").length) {
          return this.notifyPropertyChange("sortedAdvancedTrainings");
        }
      }, 500);
    },
    submit(person) {
      person
        .save()
        .then(() =>
          Promise.all([
            ...person
              .get("advancedTrainings")
              .map(advancedTraining =>
                advancedTraining.get("hasDirtyAttributes")
                  ? advancedTraining.save()
                  : null
              )
          ])
        )
        .then(() => this.set("alreadyAborted", true))
        .then(() => this.sendAction("submit"))
        .then(() => this.get("notify").success("Successfully saved!"))
        .then(() =>
          this.$("#advancedTrainingsHeader")[0].scrollIntoView({
            behavior: "smooth"
          })
        )
        .catch(() => {
          let advancedTrainings = this.get("advanced-trainings");
          advancedTrainings.forEach(advancedTraining => {
            let errors = advancedTraining.get("errors").slice();

            advancedTraining.rollbackAttributes();

            errors.forEach(({ attribute, message }) => {
              let translated_attribute = this.get("intl").t(
                `advancedTraining.${attribute}`
              );
              this.get("notify").alert(`${translated_attribute} ${message}`, {
                closeAfter: 10000
              });
            });
          });
        });
    },

    abort() {
      let advancedTrainings = this.get("person.advancedTrainings").toArray();
      advancedTrainings.forEach(advancedTraining => {
        if (advancedTraining.get("hasDirtyAttributes")) {
          advancedTraining.rollbackAttributes();
        }
      });
      this.sendAction("advancedTrainingsEditing");
    },

    abortEdit() {
      this.send("abort");
      this.set("alreadyAborted", true);
      this.$("#advancedTrainingsHeader")[0].scrollIntoView({
        behavior: "smooth"
      });
    }
  }
});
