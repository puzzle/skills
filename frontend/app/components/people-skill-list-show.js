import classic from "ember-classic-decorator";
import { observes } from "@ember-decorators/object";
import { action, computed } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";

@classic
export default class PeopleSkillListShow extends Component {
  @service router;

  init() {
    super.init(...arguments);
    this.set("levelValue", this.get("skill.level"));
    if (!this.get("skill.level")) {
      this.set("levelValue", 1);
    }
  }

  @computed("skill.level")
  get levelName() {
    const levelNames = [
      "Nicht bewertet",
      "Trainee",
      "Junior",
      "Professional",
      "Senior",
      "Expert"
    ];
    return levelNames[this.get("skill.level")];
  }

  @action
  adjustSliderStylingOnReset() {
    if (!this.get("skill.level")) {
      this.sliderHandle = this.$(".slider-handle:first");
      this.sliderHandle.removeClass("slider-handle");
      this.$(".in-selection").removeClass("in-selection");
    }
  }
}
