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

  newPeopleSkillModal: {
    submit: clickable("#people-skill-new-submit-button"),

    openModalButton: clickable(
      'a.edit-buttons[data-target="#people-skill-new-modal"]'
    ),
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
