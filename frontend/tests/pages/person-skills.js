import RSVP from "rsvp";
import {
  create,
  visitable,
  clickable,
  collection
} from "ember-cli-page-object";

const { resolve } = RSVP;

export default create({
  visit: visitable("/people/:person_id/skills"),

  filterButtons: {
    all: clickable("#memberSkillsetAll"),
    rated: clickable("#memberSkillsetRated"),
    unrated: clickable("#memberSkillsetUnrated")
  },

  newPeopleSkillModal: {
    submit: clickable("#people-skill-new-submit-button"),

    openModalButton: clickable(
      'a.edit-buttons[data-target="#people-skill-new-modal"]'
    ),
    openSkillTitleDropdown: clickable("#people-skill-new-skill"),
    skillTitleDropdownOptions: collection(".ember-power-select-option"),
    levelButtons: collection(".people-skill-new-dropdowns .slider-tick"),
    interestButtons: collection(
      ".people-skill-new-dropdowns .icon-rating-icon"
    ),
    certificateToggle: clickable('#certificate-toggle input[type="checkbox"]'),
    coreCompetenceToggle: clickable(
      '#coreCompetence-toggle input[type="checkbox"]'
    ),

    async createPeopleSkill(peopleSkill) {
      await Object.keys(peopleSkill).reduce(
        (p, key) => p.then(() => this[key](peopleSkill[key])),
        resolve()
      );

      return this.submit();
    }
  },

  peopleSkillsTable: {
    skillNames: collection(".people-skill-skillname"),
    levels: collection(".people-skill-level"),
    interests: collection(".people-skill-interest")
  }
});
