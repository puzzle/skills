import { underscore } from "@ember/string";
import DS from "ember-data";

export default DS.JSONAPISerializer.extend({
  keyForAttribute(attr) {
    return underscore(attr);
  },
  keyForRelationship(key) {
    return underscore(key);
  },
  serializeBelongsTo(snapshot, json, relationship) {
    // do not serialize the attribute!
    if (relationship.options && relationship.options.readOnly) {
      return;
    }
    this._super(...arguments);
  }
});
