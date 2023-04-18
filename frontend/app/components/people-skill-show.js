import classic from "ember-classic-decorator";
import { observes } from "@ember-decorators/object";
import { action, computed } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";

@classic
export default class PeopleSkillShow extends Component {
  @service router;

  init() {
    super.init(...arguments);
    this.set("levelValue", this.get("peopleSkill.level"));
    if (!this.get("peopleSkill.level")) {
      this.set("levelValue", 1);
    }
  }

  sleep(time) {
    return new Promise(resolve => setTimeout(resolve, time));
  }

  @action
  sliderLoading(element) {
    /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
    this.sleep(10).then(() => {
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
    });
    /* eslint-enable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
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
      this.sliderHandleFirstChild = this.element.querySelector(
        ".slider-tick-container"
      ).children[0];
      this.sliderHandleFirstChild.classList.remove("in-selection");
      this.element
        .querySelector(".slider-handle")
        .classList.remove("slider-handle");
    }
  }
}
