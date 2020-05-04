import DS from "ember-data";
import { computed } from "@ember/object";

const PeopleSkill = DS.Model.extend({
  level: DS.attr("number"),
  interest: DS.attr("number"),
  certificate: DS.attr("boolean"),
  coreCompetence: DS.attr("boolean"),

  person: DS.belongsTo("person"),
  skill: DS.belongsTo("skill"),

  isRated: computed(
    "level",
    "interest",
    "certificate",
    "coreCompetence",
    function() {
      return ["level", "interest", "certificate", "coreCompetence"]
        .map(attr => Boolean(this.get(attr)))
        .includes(true);
    }
  )
});

PeopleSkill.reopenClass({
  LEVEL_NAMES: {
    0: "Nicht bewertet",
    1: "Trainee",
    2: "Junior",
    3: "Professional",
    4: "Senior",
    5: "Expert"
  }
});

export default PeopleSkill;
