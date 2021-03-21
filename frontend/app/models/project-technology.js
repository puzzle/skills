import Model, { attr, belongsTo } from "@ember-data/model";

export default Model.extend({
  offer: attr("array"),
  project: belongsTo("project")
});
