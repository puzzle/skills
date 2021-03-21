import Model, { attr, belongsTo, hasMany } from "@ember-data/model";
import { computed } from "@ember/object";

const Person = Model.extend({
  name: attr("string"),
  birthdate: attr("date"),
  picturePath: attr("string"),
  location: attr("string"),
  maritalStatus: attr("string"),
  nationality: attr("string", { defaultValue: "CH" }),
  nationality2: attr("string"),
  title: attr("string"),
  competenceNotes: attr("string"),
  email: attr("string"),
  shortname: attr("string"),
  updatedAt: attr("date"),

  department: belongsTo("department"),
  company: belongsTo("company"),

  educations: hasMany("education"),
  advancedTrainings: hasMany("advanced-training"),
  activities: hasMany("activity"),
  projects: hasMany("project"),
  expertiseTopicSkillValues: hasMany("expertise-topic-skill-value"),
  languageSkills: hasMany("language-skill"),
  personRoles: hasMany("person-role"),
  peopleSkills: hasMany("people-skill"),

  instanceToString: computed("name", function() {
    return this.name;
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
