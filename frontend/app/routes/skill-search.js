import classic from "ember-classic-decorator";
import Route from "@ember/routing/route";
import { inject as service } from "@ember/service";

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
    },
    interest: {
      refreshModel: true,
      replace: true
    }
  };

  @service store;

  model({ skill_id, level, interest }) {
    if (skill_id) {
      return this.store.query("peopleSkill", {
        skill_id,
        rated: "true",
        level,
        interest
      });
    }
  }
}
