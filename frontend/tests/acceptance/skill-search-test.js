import { module, test } from "qunit";
import page from "frontend/tests/pages/skill-search";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { currentURL } from "@ember/test-helpers";
import { selectChoose } from "ember-power-select/test-support";

module("Acceptance | skill search", function(hooks) {
  setupApplicationTest(hooks);

  test("search peopleSkills of Rails", async function(assert) {
    assert.expect(5);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skill_search");

    let store = this.owner.__container__.lookup("service:store");
    let rails = store
      .peekAll("skill")
      .filter(skill => skill.get("title") == "Rails")
      .get("firstObject");
    await rails;
    /* eslint "no-undef": "off" */
    await selectChoose(".ember-power-select-trigger", rails.get("title"));
    assert.equal(
      currentURL(),
      "/skill_search?level=1&skill_id=" + rails.get("id")
    );
    const names = page.indexPage.peopleSkills.peopleNames
      .toArray()
      .map(name => name.text);
    assert.notOk(names.includes("ken"));
    assert.notOk(names.includes("Alice Mante"));
    assert.ok(names.includes("Bob Anderson"));
  });

  test("search peopleSkills of JUnit", async function(assert) {
    assert.expect(7);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skill_search");

    let store = this.owner.__container__.lookup("service:store");
    let junit = store
      .peekAll("skill")
      .filter(skill => skill.get("title") == "JUnit")
      .get("firstObject");
    await junit;
    /* eslint "no-undef": "off" */
    await selectChoose(".ember-power-select-trigger", junit.get("title"));
    assert.equal(
      currentURL(),
      "/skill_search?level=1&skill_id=" + junit.get("id")
    );
    const names = page.indexPage.peopleSkills.peopleNames
      .toArray()
      .map(name => name.text);
    assert.notOk(names.includes("ken"));
    assert.ok(names.includes("Alice Mante"));
    assert.notOk(names.includes("Bob Anderson"));
    // Due to some issues with the testing framework, this selects level 2
    // despite objectAt(2) implying level 3; test would still pass if fixed
    await page.skillSearchLevelSlider.levelButtons.objectAt(2).click();
    assert.equal(
      currentURL(),
      "/skill_search?level=2&skill_id=" + junit.get("id")
    );
    const newnames = page.indexPage.peopleSkills.peopleNames
      .toArray()
      .map(newnames => newnames.text);
    assert.notOk(newnames.includes("Alice Mante"));
  });
});
