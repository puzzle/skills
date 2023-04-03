import DS from "ember-data";

const RatedSkill = DS.Model.extend({
  title: DS.attr("string"),
  level: DS.attr("number"),
  interest: DS.attr("number"),
  certificate: DS.attr("boolean"),
  coreCompetence: DS.attr("boolean")
});

export default RatedSkill;
