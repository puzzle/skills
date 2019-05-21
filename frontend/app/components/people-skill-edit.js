import Component from "@ember/component";
import { isBlank } from "@ember/utils";
import { computed, observer } from "@ember/object";

export default Component.extend({
  init() {
    this._super(...arguments);
    this.set("interestLevelOptions", [0, 1, 2, 3, 4, 5]);
    this.set("levelValue", this.get("peopleSkill.level"));

    if (!this.get("peopleSkill.level")) {
      this.set("levelValue", 1);
      /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
      $(".slider-handle").ready(() => {
        /* eslint-enable no-global-jquery, no-undef, jquery-ember-run  */
        this.sliderHandle = this.$(".slider-handle:first");
        this.sliderHandle.removeClass("slider-handle");
        this.$(".in-selection").removeClass("in-selection");

        this.$(".slider").on("mouseup", () => {
          this.sliderHandle.addClass("slider-handle");
          this.notifyPropertyChange("levelValue");
        });
      });
    }
  },

  levelName: computed("peopleSkill.level", function() {
    const levelNames = [
      "Nicht bewertet",
      "Trainee",
      "Junior",
      "Professional",
      "Senior",
      "Expert"
    ];
    return levelNames[this.get("peopleSkill.level") || 0];
  }),

  levelValueChanged: observer("levelValue", function() {
    this.set("peopleSkill.level", this.get("levelValue"));
  }),

  sliderClass: computed("peopleSkill.level", function() {
    return this.get("peopleSkill.level") ? "" : "disabled-slider";
  }),

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains("ember-power-select-search-input");
  },

  actions: {
    handleFocus(select, e) {
      if (this.focusComesFromOutside(e)) {
        select.actions.open();
      }
    },

    handleBlur() {}
  }
});
