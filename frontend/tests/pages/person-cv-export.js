import { create, collection } from "ember-cli-page-object";

export default create({
  personSkillSlider: {
    levelButtons: collection("#person-level-slider .slider-tick"),
    interestButtons: collection(".people-skill-interest .icon-rating-icon")
  }
});
