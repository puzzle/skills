// app/transforms/array.js
import Transform from "@ember-data/serializer/transform";

import { A, isArray } from "@ember/array";

export default Transform.extend({
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
