import DS from "ember-data";

const Skill = DS.Model.extend({
  title: DS.attr("string"),
  radar: DS.attr("string"),
  portfolio: DS.attr("string"),
  defaultSet: DS.attr("boolean", { allowNull: true }),

  people: DS.hasMany("person"),
  peopleSkills: DS.hasMany("people-skill"),
  category: DS.belongsTo("category", { inverse: "skills" }),
  parentCategory: DS.belongsTo("category", { inverse: "childrenSkills" })
});

Skill.reopenClass({
  RADAR_OPTIONS: {
    hold: "hold",
    adopt: "adopt",
    trial: "trial",
    divorced: "assess"
  },

  PORTFOLIO_OPTIONS: { active: "aktiv", passive: "passiv", reduce: "abbauen" }
});

export default Skill;
