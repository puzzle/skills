import Service from "@ember/service";
import { computed } from "@ember/object";

// zu selected-person umbenennen
export default Service.extend({
  personId: null,
  selectedSubRoute: null,
  queryParams: null,

  clear() {
    ["personId", "selectedSubRoute", "queryParams"].forEach(param =>
      this.set(param, null)
    );
  },

  isPresent: computed("personId", "selectedSubRoute", function() {
    return !!(this.get("personId") && this.get("selectedSubRoute"));
  })
});
