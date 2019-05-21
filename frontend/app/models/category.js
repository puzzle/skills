import DS from "ember-data";

export default DS.Model.extend({
  title: DS.attr("string"),

  skills: DS.hasMany("skill", { inverse: "category" }),
  childrenSkills: DS.hasMany("skill", { inverse: "parentCategory" }),
  children: DS.hasMany("category", { inverse: "parent" }),
  parent: DS.belongsTo("category", { inverse: "children" })
});
