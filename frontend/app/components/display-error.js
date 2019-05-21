import Component from "@ember/component";
import { computed } from "@ember/object";

export default Component.extend({
  error: null,

  messageIsHTMLDocument: computed("error.message", function() {
    return /<!doctype/i.test(String(this.get("error.message")));
  })
});
