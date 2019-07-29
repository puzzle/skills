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
      skillRow: collection("#skills-list-table tr"),
      skillNames: collection("#skills-list-table .skillname"),
      skillEditButtons: collection("#skills-list-table .skill-edit-button")
    },

    skillModal: {
      closeButton: clickable(".close"),
      personNames: collection("#skill-show-modal .people-skill-skillname")
    },

    skillEdit: {
      skillName: fillable('#skills-list-table input[name="edit-skill-title"]'),
      skillDefaultSet: clickable('#skills-list-table input[type="checkbox"]'),
      save: clickable("#skills-list-table .skill-edit-save")
    }
  }
});
