import { moduleForModel } from "ember-qunit";

moduleForModel("person", "Unit | Model | person", {
  // Specify the other units that are required for this test.
  needs: [
    "model:education",
    "model:activity",
    "model:advancedTraining",
    "model:project",
    "model:competence"
  ]
});
