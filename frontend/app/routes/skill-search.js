import classic from "ember-classic-decorator";
import Route from "@ember/routing/route";

@classic
export default class SkillSearchRoute extends Route {
  queryParams = {
    skill_id: {
      refreshModel: true,
      replace: true
    },
    level: {
      refreshModel: true,
      replace: true
    }
  };

  model({ skill_id, level }) {
    if (skill_id) {
      return this.store.query("peopleSkill", {
        skill_id,
        rated: "true",
        level
      });
    }
  }
}
