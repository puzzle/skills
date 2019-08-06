import Component from "@ember/component";
import { computed, observer } from "@ember/object";
import { inject as service } from "@ember/service";

export default Component.extend({
  router: service(),

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

  didRender() {
    const currentURL = this.get("router.currentURL");
    const skillClass = currentURL == "/skills" ? "skillset" : "member-skillset";
    this.set("skillClass", skillClass);
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
  }),

  levelChanged: observer("peopleSkill.level", function() {
    this.set("levelValue", this.get("peopleSkill.level"));
  }),

  actions: {
    changePerson(person) {
      person.then(person => {
        person.reload().then(person => {
          this.get("router").transitionTo("person.skills", person.get("id"));
        });
      });
    },

    hasChanged() {
      if (!this.get("peopleSkill.level")) {
        this.sliderHandle = this.$(".slider-handle:first");
        this.sliderHandle.removeClass("slider-handle");
        this.$(".in-selection").removeClass("in-selection");
      }
    }
  }
});
