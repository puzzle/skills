import Controller from "@ember/controller";

export default Controller.extend({
  // ember needs this to set the active
  // class on the current filter button
  queryParams: ["personId", "rated"]
});
