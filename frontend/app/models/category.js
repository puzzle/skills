import Model, { attr, hasMany, belongsTo } from "@ember-data/model";

export default Model.extend({
  title: attr("string"),
  position: attr("number"),

  skills: hasMany("skill", { inverse: "category" }),
  childrenSkills: hasMany("skill", { inverse: "parentCategory" }),
  children: hasMany("category", { inverse: "parent" }),
  parent: belongsTo("category", { inverse: "children" })
});
