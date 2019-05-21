import Component from "@ember/component";
import { computed } from "@ember/object";

export default Component.extend({
  init() {
    this._super(...arguments);
    this.set("levelValue", this.get("peopleSkill.level"));
    if (!this.get("peopleSkill.level")) {
      this.set("levelValue", 1);
      /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
      $(".slider-handle").ready(() => {
        /* eslint-enable no-global-jquery, no-undef, jquery-ember-run  */
        this.sliderHandle = this.$(".slider-handle:first");
        this.sliderHandle.removeClass("slider-handle");
        this.$(".in-selection").removeClass("in-selection");
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
    return levelNames[this.get("peopleSkill.level")];
  })
});
