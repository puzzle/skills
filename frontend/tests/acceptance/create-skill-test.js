import { module, test } from "qunit";
import page from "frontend/tests/pages/skills-index";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { selectChoose } from "ember-power-select/test-support";
import { currentURL } from "@ember/test-helpers";

module("Acceptance | create skill", function(hooks) {
  setupApplicationTest(hooks);

  test("creating a new skill", async function(assert) {
    assert.expect(3);

    await page.indexPage.visit();
    assert.equal(currentURL(), "/skills");
    let names_before = page.indexPage.skills.skillNames
      .toArray()
      .map(name => name.text);
    assert.notOk(names_before.includes("• RVM"));

    await page.indexPage.openModalButton();
    await page.indexPage.title("RVM");
    /* eslint "no-undef": "off" */
    await selectChoose("#skill-new-category", ".ember-power-select-option", 1);
    await selectChoose("#skill-new-radar", ".ember-power-select-option", 2);
    await selectChoose("#skill-new-portfolio", ".ember-power-select-option", 1);
    await page.indexPage.newSkillSubmitButton();

    let names = page.indexPage.skills.skillNames
      .toArray()
      .map(name => name.text);
    assert.ok(names.includes("• RVM"));
  });
});
