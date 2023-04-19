import classic from "ember-classic-decorator";
import { observes } from "@ember-decorators/object";
import { action, computed } from "@ember/object";
import Component from "@ember/component";
import { isBlank } from "@ember/utils";
import { inject as service } from "@ember/service";
import config from "../config/environment";

@classic
export default class PeopleSkillEdit extends Component {
  @service router;

  init() {
    super.init(...arguments);
    this.set("levelValue", this.get("peopleSkill.level"));

    if (!this.get("peopleSkill.level")) {
      this.set("levelValue", 1);
    }
  }

  @action
  sliderLoading(element) {
    // Sorry for doing this like that, but we couldn't make it work with element.querySelector().ready().
    /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
    if (
      config.environment !== "test" &&
      (document.querySelector("#peopleSkillsHeader").contains(element) ||
        document.querySelector("#new-people-skills-show").contains(element))
    ) {
      if (
        document.querySelector("#peopleSkillsHeader").contains(element) &&
        this.get("peopleSkill.level") !== 0
      )
        return;

      $(".slider-handle").ready(() => {
        this.sliderTickContainer = element.querySelector(
          ".slider-tick-container"
        ).children[0];
        this.sliderTickContainer.classList.remove("in-selection");

        this.sliderHandle = element.querySelector(".slider-handle");
        this.sliderHandle.classList.remove("slider-handle");

        element.addEventListener("mouseup", () => {
          this.sliderHandle.classList.add("slider-handle");
          this.notifyPropertyChange("levelValue");
        });
      });
    }
    /* eslint-enable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
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
