import { inject as service } from "@ember/service";
import Component from "@ember/component";
import { computed } from "@ember/object";
import { on } from "@ember/object/evented";
import { EKMixin, keyUp } from "ember-keyboard";

export default Component.extend(EKMixin, {
  store: service(),
  intl: service(),

  newAdvancedTraining: computed("personId", function() {
    return this.store.createRecord("advancedTraining");
  }),

  activateKeyboard: on("init", function() {
    this.set("keyboardActivated", true);
  }),

  abortAdvancedTrainingNew: on(keyUp("Escape"), function() {
    if (this.get("newAdvancedTraining.isNew")) {
      this.newAdvancedTraining.destroyRecord();
    }
    this.done(false);
  }),

  willDestroyElement() {
    if (this.get("newAdvancedTraining.isNew")) {
      this.newAdvancedTraining.destroyRecord();
    }
  },
  setInitialState(context) {
    context.set(
      "newAdvancedTraining",
      context.get("store").createRecord("advancedTraining")
    );
    context.sendAction("done", true);
  },

  actions: {
    abortNew(event) {
      event.preventDefault();
      this.sendAction("done", false);
    },

    submit(newAdvancedTraining, initNew, event) {
      event.preventDefault();
      let person = this.store.peekRecord("person", this.personId);
      newAdvancedTraining.set("person", person);
      return newAdvancedTraining
        .save()
        .then(advancedTraining => {
          this.sendAction("done");
          if (initNew) this.sendAction("setInitialState", this);
        })
        .then(() => this.notify.success("Weiterbildung wurde hinzugefügt!"))
        .catch(() => {
          this.set("newAdvancedTraining.person", null);
          this.get("newAdvancedTraining.errors").forEach(
            ({ attribute, message }) => {
              let translated_attribute = this.intl.t(
                `advancedTraining.${attribute}`
              );
              this.notify.alert(`${translated_attribute} ${message}`, {
                closeAfter: 10000
              });
            }
          );
        });
    }
  }
});
