import { inject as service } from "@ember/service";
import Component from "@ember/component";
import { computed } from "@ember/object";
import { on } from "@ember/object/evented";
import { EKMixin, keyUp } from "ember-keyboard";

export default Component.extend(EKMixin, {
  store: service(),
  intl: service(),

  newActivity: computed("personId", function() {
    return this.get("store").createRecord("activity");
  }),

  activateKeyboard: on("init", function() {
    this.set("keyboardActivated", true);
  }),

  abortActivityNew: on(keyUp("Escape"), function() {
    if (this.get("newActivity.isNew")) {
      this.get("newActivity").destroyRecord();
    }
    this.done(false);
  }),

  willDestroyElement() {
    if (this.get("newActivity.isNew")) {
      this.get("newActivity").destroyRecord();
    }
  },

  setInitialState(context) {
    context.set("newActivity", context.get("store").createRecord("activity"));
    context.sendAction("done", true);
  },

  addMissingMonthWarning(newActivity) {
    if (
      !newActivity.monthFrom ||
      (!newActivity.monthTo && newActivity.yearTo)
    ) {
      document.getElementById("missing-month-warning").style.display = "block";
      return true;
    } else if (
      document.getElementById("missing-month-warning").style.display == "block"
    ) {
      document.getElementById("missing-month-warning").style.display = "none";
      return false;
    }
    return false;
  },

  actions: {
    abortNew(event) {
      event.preventDefault();
      this.sendAction("done", false);
    },

    submit(newActivity, initNew, monthNeeded, event) {
      event.preventDefault();
      if (monthNeeded && this.addMissingMonthWarning(newActivity)) return;
      let person = this.get("store").peekRecord("person", this.get("personId"));
      newActivity.set("person", person);
      return newActivity
        .save()
        .then(activity => {
          this.sendAction("done", false);
          if (initNew) this.sendAction("setInitialState", this);
        })
        .then(() => this.get("notify").success("Aktivität wurde hinzugefügt!"))
        .catch(() => {
          this.set("newActivity.person", null);
          this.get("newActivity.errors").forEach(({ attribute, message }) => {
            let translated_attribute = this.get("intl").t(
              `activity.${attribute}`
            );
            this.get("notify").alert(`${translated_attribute} ${message}`, {
              closeAfter: 10000
            });
          });
        });
    }
  }
});
