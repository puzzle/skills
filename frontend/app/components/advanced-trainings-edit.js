import { inject as service } from "@ember/service";
import Component from "@glimmer/component";
import sortByYear from "../utils/sort-by-year";
import { on } from "@ember/object/evented";
import { EKMixin, keyUp } from "ember-keyboard";
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
    //observer("person", function() {
    this.abort();
    this.alreadyAborted = true;
  },

  activateKeyboard() {
    //on("init", function() {
    this.keyboardActivated = true;
  },

  abortAdvancedTrainings() {
    //on(keyUp("Escape"), function() {
    this.send("abortEdit");
  },

  get sortedAdvancedTrainings() {
    return sortByYear(this.args.person.activities);
  },

  actions: {
    notify() {
      let length = this.sortedAdvancedTrainings.length;
      setTimeout(() => {
        if (length > this.sortedAdvancedTrainings.length) {
          return this.notifyPropertyChange(this.sortedAdvancedTrainings);
        }
      }, 500);
    },
    submit(person) {
      person
        .save()
        .then(() =>
          Promise.all([
            ...person.advancedTrainings.map(advancedTraining =>
              advancedTraining.get("hasDirtyAttributes")
                ? advancedTraining.save()
                : null
            )
          ])
        )
        .then(() => (this.alreadyAborted = true))
        .then(() => this.sendAction("submit"))
        .then(() => this.notify.success("Successfully saved!"))
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
              this.notify.alert(`${translated_attribute} ${message}`, {
                closeAfter: 10000
              });
            });
          });
        });
    },

    abort() {
      let advancedTrainings = this.person.advancedTrainings.toArray();
      advancedTrainings.forEach(advancedTraining => {
        if (advancedTraining.get("hasDirtyAttributes")) {
          advancedTraining.rollbackAttributes();
        }
      });
      this.sendAction("advancedTrainingsEditing");
    },

    abortEdit() {
      this.abort();
      this.alreadyAborted = true;
      this.$("#advancedTrainingsHeader")[0].scrollIntoView({
        behavior: "smooth"
      });
    }
  }
});
