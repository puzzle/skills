import Route from "@ember/routing/route";

export default Route.extend({
  queryParams: {
    skill_id: {
      refreshModel: true,
      replace: true
    }
  },

  model({ skill_id }) {
    if (skill_id) {
      return this.store.query("peopleSkill", {
        skill_id,
        rated: "true"
      });
    }
  }
});
