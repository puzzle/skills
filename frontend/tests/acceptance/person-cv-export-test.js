import { module, test } from "qunit";
import applicationPage from "frontend/tests/pages/application";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { selectChoose } from "ember-power-select/test-support";

module("Acceptance | person cv export", function(hooks) {
  setupApplicationTest(hooks);

  test("should generate right url", async function(assert) {
    // Go to the start page and select a user from the dropdown
    await applicationPage.visitHome("/");
    await selectChoose("#people-search", ".ember-power-select-option", 0);

    // TODO
    // Navigate on cv export window
    // Choose a location
    // Check if download service file() is called with right url or
    // Check if backend received right data
  });
});
