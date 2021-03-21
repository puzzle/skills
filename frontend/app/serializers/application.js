import JSONAPISerializer from "@ember-data/serializer/json-api";
import { underscore } from "@ember/string";

export default JSONAPISerializer.extend({
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
