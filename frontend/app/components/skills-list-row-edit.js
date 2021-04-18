import Component from "@ember/component";
import { computed } from "@ember/object";
import { isBlank } from "@ember/utils";
import Skill from "../models/skill";
import Changeset from "ember-changeset";
import { inject as service } from "@ember/service";

export default Component.extend({
  tagName: "tr",
  store: service(),

  selectedParentCategory: null,

  init() {
    this._super(...arguments);
    this.radarOptions = Object.values(Skill.RADAR_OPTIONS);
    this.portfolioOptions = Object.values(Skill.PORTFOLIO_OPTIONS);

    this.set("changeset", new Changeset(this.get("skill")));
    this.set("selectedParent", this.get("skill.category.parent"));
    this.set("fallbackCategory", this.get("skill.category"));
  },

  selectableChildCategories: computed(
    "childCategories",
    "selectedParent",
    function() {
      return this.get("childCategories").then(categories =>
        categories.filter(
          c => c.get("parent.id") == this.get("selectedParent.id")
        )
      );
    }
  ),

  // checks if the focus of the event e comes from outside the current powerselect or the inside
  focusComesFromOutside(e) {
    if (!this.get("isAdmin")) return;

    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains("ember-power-select-search-input");
  },

  actions: {
    abort() {
      if (!this.get("isAdmin")) return;
      this.get("skill").rollbackAttributes();
      this.set("skill.category", this.get("fallbackCategory"));
      this.sendAction("stopEditing");
    },

    submit() {
      if (!this.get("isAdmin")) return;
      if (this.get("changeset.isPristine")) return;
      const fallbackTitle = this.get("skill.title");
      this.get("changeset")
        .save()
        .then(() => this.sendAction("stopEditing"))
        .then(() => this.get("notify").success("Successfully saved!"))
        .catch(() => {
          let errors = this.get("skill.errors").slice(); // clone array as rollbackAttributes mutates
          // we set this to the original title because otherwise you would get an empty delete
          // prompt when trying to save an empty skill and then trying to delete it
          this.set("skill.title", fallbackTitle);
          errors.forEach(({ attribute, message }) => {
            let translated_attribute = this.get("intl").t(`skill.${attribute}`);
            this.get("notify").alert(`${translated_attribute} ${message}`, {
              closeAfter: 10000
            });
          });
        });
    },

    setParentCategory(parentCategory) {
      if (this.get("changeset.category.parent") != parentCategory) {
        this.set("changeset.category", { title: "" });
      }
      this.set("selectedParent", parentCategory);
    },

    handleFocus(select, e) {
      if (this.focusComesFromOutside(e)) {
        select.actions.open();
      }
    },

    handleBlur() {}
  }
});
