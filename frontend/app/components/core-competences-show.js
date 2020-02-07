import classic from "ember-classic-decorator";
import { observes } from "@ember-decorators/object";
import { computed } from "@ember/object";
import { inject as service } from "@ember/service";
import Component from "@ember/component";

@classic
export default class CoreCompetencesShow extends Component {
  @service
  store;

  init() {
    super.init(...arguments);
    this.parentCategories = this.get("store").query("category", {
      scope: "parents"
    });
    this.refreshCoreCompetencesObj();
  }

  @observes("person.peopleSkills")
  personChanged() {
    super.personChanged;
    this.refreshCoreCompetencesObj();
  }

  refreshCoreCompetencesObj() {
    let hash = {};
    this.get("parentCategories").then(parentCategories => {
      parentCategories.toArray().forEach(category => {
        let skills = category
          .get("childrenSkills")
          .map(skill => {
            if (
              this.get("coreCompetenceSkills")
                .map(s => s.get("id"))
                .includes(skill.get("id"))
            )
              return skill;
          })
          .filter(s => s !== undefined);
        if (skills.length) hash[category.get("title")] = skills;
      });
      this.set("coreCompetencesObj", hash);
    });
  }

  @computed("person.peopleSkills")
  get coreCompetenceSkills() {
    return this.get("person.peopleSkills")
      .map(ps => {
        if (ps.get("coreCompetence")) return ps.get("skill");
      })
      .filter(s => s !== undefined);
  }

  @computed("coreCompetenceSkills")
  get coreCompetenceSkillsAmount() {
    return this.get("coreCompetenceSkills.length");
  }
}
