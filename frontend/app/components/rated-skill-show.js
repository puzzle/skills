import classic from "ember-classic-decorator";
import { action, computed } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";

@classic
export default class RatedSkillShow extends Component {
  @service router;

  init() {
    super.init(...arguments);
  }

  @computed("level")
  get levelValue() {
    return this.get("level") || 1;
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
      this.sliderHandleFirstChild = this.element.querySelector(
        ".slider-tick-container"
      ).children[0];
      this.sliderHandleFirstChild.classList.remove("in-selection");
      this.element
        .querySelector(".slider-handle")
        .classList.remove("slider-handle");
    }
  }
  @action
  sliderLoading(element) {
    /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
    $(".slider-handle").ready(() => {
      if (this.get("peopleSkill.level") === 0) {
        this.sliderTickContainer = element.querySelector(
          ".slider-tick-container"
        ).children[0];
        this.sliderTickContainer.classList.remove("in-selection");

        this.sliderHandle = element.querySelector(".slider-handle");
        this.sliderHandle.classList.remove("slider-handle");
      }
    });
    /* eslint-enable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
  }
}
