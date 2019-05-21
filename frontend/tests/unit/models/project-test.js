import { moduleForModel } from "ember-qunit";

moduleForModel("project", "Unit | Model | project", {
  // Specify the other units that are required for this test.
  needs: ["model:person", "model:project technology"]
});
