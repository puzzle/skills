import DS from "ember-data";

export default DS.Model.extend({
  short_name: DS.attr("string"),
  adress_information: DS.attr("string"),
  country: DS.attr("string")
});
