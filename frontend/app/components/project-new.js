import { inject as service } from "@ember/service";
import Component from "@ember/component";
import { isBlank } from "@ember/utils";
import { on } from "@ember/object/evented";
import { EKMixin, keyUp } from "ember-keyboard";

export default Component.extend(EKMixin, {
  store: service(),
  intl: service(),

  init() {
    this._super(...arguments);
    this.set("newProject", this.store.createRecord("project"));
  },

  activateKeyboard: on("init", function() {
    this.set("keyboardActivated", true);
  }),

  abortProjectNew: on(keyUp("Escape"), function() {
    if (this.get("newProject.isNew")) {
      this.newProject.destroyRecord();
    }
    this.done(false);
  }),

  suggestion(term) {
    return `"${term}" mit Enter hinzufügen!`;
  },

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains("ember-power-select-search-input");
  },

  setInitialState(context) {
    context.set("newProject", context.get("store").createRecord("project"));
    context.sendAction("done", true);
  },

  actions: {
    abortNew(event) {
      event.preventDefault();
      this.newProject.destroyRecord();
      this.sendAction("done", false);
    },

    submit(newProject, initNew, event) {
      event.preventDefault();
      let person = this.store.peekRecord("person", this.personId);
      newProject.set("person", person);
      return newProject
        .save()
        .then(() => {
          this.notify.success("Projekt wurde hinzugefügt!");
          this.sendAction("done", false);
          if (initNew) this.sendAction("setInitialState", this);
        })
        .catch(() => {
          newProject.set("person", null);
          newProject.get("errors").forEach(({ attribute, message }) => {
            let translated_attribute = this.intl.t(`project.${attribute}`);
            this.notify.alert(`${translated_attribute} ${message}`, {
              closeAfter: 10000
            });
          });
        });
    },

    handleFocus(select, e) {
      if (this.focusComesFromOutside(e)) {
        select.actions.open();
      }
    },

    handleBlur() {},

    createTechnology(selected, searchText) {
      let options = this.options;
      if (!options.includes(searchText)) {
        this.options.pushObject(searchText);
      }
      if (selected.includes(searchText)) {
        this.notify.alert("Already added!", { closeAfter: 4000 });
      } else {
        selected.pushObject(searchText);
      }
    }
  }
});
