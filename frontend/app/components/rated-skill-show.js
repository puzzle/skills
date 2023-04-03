import classic from "ember-classic-decorator";
import { action, computed } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";

@classic
export default class RatedSkillShow extends Component {
  @service router;

  init() {
    super.init(...arguments);
    this.set("levelValue", this.get("level"));
    if (!this.get("level")) {
      this.set("levelValue", 1);
    }
  }

  @computed("level")
  get levelName() {
    const levelNames = [
      "Nicht bewertet",
      "Trainee",
      "Junior",
      "Professional",
      "Senior",
      "Expert"
    ];
    return levelNames[this.get("level")];
  }

  @action
  adjustSliderStylingOnReset() {
    if (!this.get("level")) {
      this.sliderHandle = this.$(".slider-handle:first");
      this.sliderHandle.removeClass("slider-handle");
      this.$(".in-selection").removeClass("in-selection");
    }
  }
}
