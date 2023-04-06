import classic from "ember-classic-decorator";
import { observes } from "@ember-decorators/object";
import { action, computed } from "@ember/object";
import Component from "@ember/component";
import { isBlank } from "@ember/utils";

@classic
export default class PeopleSkillEdit extends Component {
  init() {
    super.init(...arguments);
    this.set("levelValue", this.get("peopleSkill.level"));

    if (!this.get("peopleSkill.level")) {
      this.set("levelValue", 1);
      /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
      $(".slider-handle").ready(() => {
        this.sliderHandle = $(".slider-handle:first");
        if (!this.sliderHandle) return;
        this.sliderHandle.removeClass("slider-handle");
        $(".in-selection").removeClass("in-selection");

        $(this, ".slider").on("mouseup", () => {
          this.sliderHandle.addClass("slider-handle");
        });
      });
      /* eslint-enable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
    }
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
    return levelNames[this.get("peopleSkill.level") || 0];
  }

  @observes("levelValue")
  levelValueChanged() {
    this.set("peopleSkill.level", this.get("levelValue"));
  }

  @computed("peopleSkill.level")
  get sliderClass() {
    return this.get("peopleSkill.level") ? "" : "disabled-slider";
  }

  focusComesFromOutside(e) {
    let blurredEl = e.relatedTarget;
    if (isBlank(blurredEl)) {
      return false;
    }
    return !blurredEl.classList.contains("ember-power-select-search-input");
  }

  @action
  handleFocus(select, e) {
    if (this.focusComesFromOutside(e)) {
      select.actions.open();
    }
  }

  @action
  handleBlur() {}
}
