import DS from "ember-data";
import { computed } from "@ember/object";

const Person = DS.Model.extend({
  name: DS.attr("string"),
  birthdate: DS.attr("date"),
  picturePath: DS.attr("string"),
  location: DS.attr("string"),
  maritalStatus: DS.attr("string", { defaultValue: "single" }),
  nationality: DS.attr("string", { defaultValue: "CH" }),
  nationality2: DS.attr("string"),
  title: DS.attr("string"),
  competenceNotes: DS.attr("string"),
  email: DS.attr("string"),
  shortname: DS.attr("string"),
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

  @computed("name")
  get instanceToString() {
    return this.name;
  },

  @computed("maritalStatus")
  get maritalStatusView() {
    return Person.MARITAL_STATUSES[this.maritalStatus];
  },

  set maritalStatusView(maritalStatus) {
    this.maritalStatus = Object.keys(Person.MARITAL_STATUSES).find(
      key => Person.MARITAL_STATUSES[key] === maritalStatus
    );
  }
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
