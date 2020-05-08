import DS from "ember-data";
import { computed } from "@ember/object";

const Person = DS.Model.extend({
  name: DS.attr("string"),
  birthdate: DS.attr("date"),
  picturePath: DS.attr("string"),
  location: DS.attr("string"),
  maritalStatus: DS.attr("string"),
  nationality: DS.attr("string", { defaultValue: "CH" }),
  nationality2: DS.attr("string"),
  title: DS.attr("string"),
  competenceNotes: DS.attr("string"),
  email: DS.attr("string"),
  updatedAt: DS.attr("date"),

  department: DS.belongsTo("department"),
  company: DS.belongsTo("company"),

  educations: DS.hasMany("education"),
  advancedTrainings: DS.hasMany("advanced-training"),
  activities: DS.hasMany("activity"),
  projects: DS.hasMany("project"),
  expertiseTopicSkillValues: DS.hasMany("expertise-topic-skill-value"),
  languageSkills: DS.hasMany("language-skill"),
  personRoles: DS.hasMany("person-role"),
  peopleSkills: DS.hasMany("people-skill"),

  instanceToString: computed("name", function() {
    return this.get("name");
  })
});

Person.reopenClass({
  MARITAL_STATUSES: {
    single: "ledig",
    married: "verheiratet",
    registered_partnership: "eingetragene Partnerschaft",
    divorced: "geschieden"
  }
});

export default Person;
