import {
  create,
  visitable,
  clickable,
  fillable,
  collection
} from "ember-cli-page-object";

export default create({
  indexPage: {
    visit: visitable("/skills"),
    allFilterButton: clickable("#defaultFilterAll"),
    newFilterButton: clickable("#defaultFilterNew"),
    defaultFilterButton: clickable("#defaultFilterDefault"),
    skillsetSearchfield: fillable("#skillsetSearchfield"),
    openModalButton: clickable("#new-skill-link"),
    title: fillable('[name="new-skill-title"]'),
    defaultSetToggle: clickable('#default-set-toggle input[type="checkbox"]'),
    newSkillSubmitButton: clickable("#skill-new-submit-button"),
    skills: {
      skillNames: collection("#skills-list-table .skillname")
    },

    skillModal: {
      closeButton: clickable(".close"),
      personNames: collection("#skill-show-modal .people-skill-skillname")
    }
  }
});
