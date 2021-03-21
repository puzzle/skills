import Model, { attr, belongsTo } from "@ember-data/model";
import { computed } from "@ember/object";

const PeopleSkill = Model.extend({
  level: attr("number"),
  interest: attr("number"),
  certificate: attr("boolean"),
  coreCompetence: attr("boolean"),

  person: belongsTo("person"),
  skill: belongsTo("skill"),

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
