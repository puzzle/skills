import {
  create,
  visitable,
  collection,
  clickable
} from "ember-cli-page-object";

export default create({
  indexPage: {
    visit: visitable("/skill_search"),
    peopleSkills: {
      peopleNames: collection(".people-skill-skillname span")
    }
  },

  skillSearchLevelSlider: {
    levelButtons: collection(
      ".people-skill-level .skillsearch-selection-slider .slider-tick"
    )
  },

  addSkills: clickable("#addSkillsButton")
});
