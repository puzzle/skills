import DS from "ember-data";
import { computed } from "@ember/object";

const Skill = DS.Model.extend({
  title: DS.attr("string"),
  radar: DS.attr("string"),
  portfolio: DS.attr("string"),
  defaultSet: DS.attr("boolean", { allowNull: true }),

  people: DS.hasMany("person"),
  peopleSkills: DS.hasMany("people-skill"),
  category: DS.belongsTo("category", { inverse: "skills" }),
  parentCategory: DS.belongsTo("category", {
    inverse: "childrenSkills",
    readOnly: true
  }),

  instanceToString: computed("title", function() {
    return this.get("title");
  })
});

Skill.reopenClass({
  RADAR_OPTIONS: {
    hold: "hold",
    adopt: "adopt",
    trial: "trial",
    assess: "assess",
    na: "n/a"
  },

  PORTFOLIO_OPTIONS: {
    active: "aktiv",
    passive: "passiv",
    reduce: "abbauen",
    nein: "nein"
  }
});

export default Skill;
