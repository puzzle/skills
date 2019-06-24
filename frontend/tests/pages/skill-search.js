import { create, visitable, collection } from "ember-cli-page-object";

export default create({
  indexPage: {
    visit: visitable("/skill_search"),
    peopleSkills: {
      peopleNames: collection(".people-skill-skillname span")
    }
  }
});
