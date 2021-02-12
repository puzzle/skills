import DS from "ember-data";

export default DS.Model.extend({
  shortName: DS.attr("string"),
  adressInformation: DS.attr("string"),
  country: DS.attr("string")
});
