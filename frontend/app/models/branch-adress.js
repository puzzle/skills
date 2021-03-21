import Model, { attr } from "@ember-data/model";

export default Model.extend({
  shortName: attr("string"),
  adressInformation: attr("string"),
  country: attr("string"),
  defaultBranchAdress: attr("boolean")
});
