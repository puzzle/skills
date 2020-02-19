import { module, test } from "qunit";
import page from "frontend/tests/pages/skills-index";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { currentURL } from "@ember/test-helpers";
import { selectChoose } from "ember-power-select/test-support";

module("Acceptance | edit skill", function(hooks) {
  setupApplicationTest(hooks);

  test("edits Rails to Travis CI", async function(assert) {
    assert.expect(7);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skills");

    assert.equal(page.indexPage.skills.skillNames.toArray()[2].text, "Rails");
    await page.indexPage.skills.skillEditButtons.toArray()[2].clickOn();

    await page.indexPage.skillEdit.skillName("Travis CI");
    await page.indexPage.skillEdit.skillDefaultSet();
    /* eslint "no-undef": "off" */
    await selectChoose(".skill-edit-parent-category", "System-Engineering");
    await selectChoose(".skill-edit-child-category", "Linux-Engineering");
    await selectChoose(".skill-edit-radar", "assess");
    await selectChoose(".skill-edit-portfolio", "aktiv");
    await page.indexPage.skillEdit.save();

    let rows = page.indexPage.skills.skillRow.toArray()[3].text;
    assert.ok(rows.includes("Travis CI"));
    assert.ok(rows.includes("System-Engineering"));
    assert.ok(rows.includes("Linux-Engineering"));
    assert.ok(rows.includes("assess"));
    assert.ok(rows.includes("aktiv"));
  });
});
