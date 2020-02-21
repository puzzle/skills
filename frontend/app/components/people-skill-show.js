import classic from "ember-classic-decorator";
import { observes } from "@ember-decorators/object";
import { action, computed } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";

@classic
export default class PeopleSkillShow extends Component {
  @service
  router;

  init() {
    super.init(...arguments);
    this.set("levelValue", this.get("peopleSkill.level"));
    if (!this.get("peopleSkill.level")) {
      this.set("levelValue", 1);
      /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
      $(".slider-handle").ready(() => {
        /* eslint-enable no-global-jquery, no-undef, jquery-ember-run  */
        this.sliderHandle = this.$(".slider-handle:first");
        if (!this.sliderHandle) return;
        this.sliderHandle.removeClass("slider-handle");
        this.$(".in-selection").removeClass("in-selection");
      });
    }
  }

  didRender() {
    const currentURL = this.get("router.currentURL");
    const skillClass = currentURL == "/skills" ? "skillset" : "member-skillset";
    this.set("skillClass", skillClass);
  }

  @computed("peopleSkill.level")
  get levelName() {
    const levelNames = [
      "Nicht bewertet",
      "Trainee",
      "Junior",
      "Professional",
      "Senior",
      "Expert"
    ];
    return levelNames[this.get("peopleSkill.level")];
  }

  @observes("peopleSkill.level")
  levelChanged() {
    this.set("levelValue", this.get("peopleSkill.level"));
  }

  @action
  changePerson(person) {
    person.then(person => {
      person.reload().then(person => {
        this.get("router").transitionTo("person.skills", person.id);
      });
    });
  }

  @action
  adjustSliderStylingOnReset() {
    if (!this.get("peopleSkill.level")) {
      this.sliderHandle = this.$(".slider-handle:first");
      this.sliderHandle.removeClass("slider-handle");
      this.$(".in-selection").removeClass("in-selection");
    }
  }
}
