// app/transforms/array.js
import DS from "ember-data";
import { A } from "@ember/array";
import { isArray } from "@ember/array";

export default DS.Transform.extend({
  deserialize(serialized) {
    if (isArray(serialized)) {
      return A(serialized);
    } else {
      return A();
    }
  },

  serialize(deserialized) {
    if (isArray(deserialized)) {
      return A(deserialized);
    } else {
      return A();
    }
  }
});
