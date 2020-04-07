import { module, test } from "qunit";
import page from "frontend/tests/pages/skills-index";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { currentURL } from "@ember/test-helpers";

module("Acceptance | show skill", function(hooks) {
  setupApplicationTest(hooks);

  test("shows Rails and its peopleSkills", async function(assert) {
    assert.expect(3);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skills");

    await page.indexPage.skills.skillNames.toArray()[3].clickOn();

    let names = page.indexPage.skillModal.personNames
      .toArray()
      .map(name => name.text);
    assert.notOk(names.includes("ken"));
    assert.ok(names.includes("Bob Anderson"));
    await page.indexPage.skillModal.closeButton();
  });

  test("shows JUnit and its peopleSkills", async function(assert) {
    assert.expect(3);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skills");

    await page.indexPage.skills.skillNames.toArray()[2].clickOn();

    let names = page.indexPage.skillModal.personNames
      .toArray()
      .map(name => name.text);
    assert.notOk(names.includes("ken"));
    assert.ok(names.includes("Alice Mante"));
    await page.indexPage.skillModal.closeButton();
  });
});
