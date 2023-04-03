import DS from "ember-data";

const PeopleSearchSkill = DS.Model.extend({
  person: DS.belongsTo("person"),
  skills: DS.hasMany("rated-skill")
});

export default PeopleSearchSkill;
