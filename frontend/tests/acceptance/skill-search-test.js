import { module, test } from "qunit";
import page from "frontend/tests/pages/skill-search";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { currentURL } from "@ember/test-helpers";
import { selectChoose } from "ember-power-select/test-support";
import { waitUntil } from "@ember/test-helpers";

module("Acceptance | skill search", function(hooks) {
  setupApplicationTest(hooks);

  test("search peopleSkills of Rails", async function(assert) {
    assert.expect(9);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skill_search?interest=&level=&skill_id=");

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
      "/skill_search?interest=1&level=1&skill_id=" + rails.get("id")
    );
    const names = page.indexPage.peopleSkills.peopleNames
      .toArray()
      .map(name => name.text);
    assert.notOk(names.includes("ken"));
    assert.notOk(names.includes("Alice Mante"));
    assert.ok(names.includes("Bob Anderson"));

    // Wait until the level slider is loaded
    await waitUntil(() => page.skillSearchLevelSlider.levelButtons.length > 0);

    await page.skillSearchLevelSlider.levelButtons.objectAt(2).click();
    assert.equal(
      currentURL(),
      "/skill_search?interest=1&level=3&skill_id=" + rails.get("id")
    );
    const names2 = page.indexPage.peopleSkills.peopleNames
      .toArray()
      .map(names2 => names2.text);
    assert.ok(names2.includes("Bob Anderson"));
    await page.skillSearchLevelSlider.interestButtons.objectAt(4).clickOn();
    assert.equal(
      currentURL(),
      "/skill_search?interest=5&level=3&skill_id=" + rails.get("id")
    );
    const names3 = page.indexPage.peopleSkills.peopleNames
      .toArray()
      .map(names3 => names3.text);
    assert.ok(names3.includes("Bob Anderson"));
  });

  test("search peopleSkills of JUnit", async function(assert) {
    assert.expect(11);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skill_search?interest=&level=&skill_id=");

    let store = this.owner.__container__.lookup("service:store");
    let junit = store
      .peekAll("skill")
      .filter(skill => skill.get("title") == "JUnit")
      .get("firstObject");
    await junit;
    await selectChoose(".ember-power-select-trigger", junit.get("title"));
    assert.equal(
      currentURL(),
      "/skill_search?interest=1&level=1&skill_id=" + junit.get("id")
    );
    const names = page.indexPage.peopleSkills.peopleNames
      .toArray()
      .map(name => name.text);
    assert.notOk(names.includes("ken"));
    assert.ok(names.includes("Alice Mante"));
    assert.notOk(names.includes("Bob Anderson"));

    await waitUntil(() => page.skillSearchLevelSlider.levelButtons.length > 2);

    await page.skillSearchLevelSlider.levelButtons.objectAt(2).click();
    assert.equal(
      currentURL(),
      "/skill_search?interest=1&level=3&skill_id=" + junit.get("id")
    );
    const names2 = page.indexPage.peopleSkills.peopleNames
      .toArray()
      .map(names2 => names2.text);
    assert.notOk(names2.includes("Alice Mante"));
    await page.skillSearchLevelSlider.levelButtons.objectAt(0).click();
    await page.skillSearchLevelSlider.interestButtons.objectAt(3).click();
    assert.equal(
      currentURL(),
      "/skill_search?interest=4&level=1&skill_id=" + junit.get("id")
    );
    const names3 = page.indexPage.peopleSkills.peopleNames
      .toArray()
      .map(names3 => names3.text);
    assert.ok(names3.includes("Alice Mante"));
    await page.skillSearchLevelSlider.levelButtons.objectAt(2).click();
    await page.skillSearchLevelSlider.interestButtons.objectAt(4).clickOn();
    assert.equal(
      currentURL(),
      "/skill_search?interest=5&level=3&skill_id=" + junit.get("id")
    );
    const names4 = page.indexPage.peopleSkills.peopleNames
      .toArray()
      .map(names4 => names4.text);
    assert.notOk(names4.includes("Alice Mante"));
  });

  test("search multiple skills", async function(assert) {
    assert.expect(10);
    await page.indexPage.visit();
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
    assert.ok(names.includes("Charlie Ford"));
    await page.addSkills();
    let cunit = store
      .peekAll("skill")
      .filter(skill => skill.get("title") == "cunit")
      .get("firstObject");
    await cunit;
    /* eslint "no-undef": "off" */
    await selectChoose(".power-select-1", ".ember-power-select-option", 1);
    assert.equal(
      currentURL(),
      "/skill_search?level=1%2C1&skill_id=" +
        rails.get("id") +
        "%2C" +
        cunit.get("id")
    );
    const names2 = page.indexPage.peopleSkills.peopleNames
      .toArray()
      .map(name => name.text);
    assert.notOk(names2.includes("ken"));
    assert.notOk(names2.includes("Alice Mante"));
    assert.notOk(names2.includes("Bob Anderson"));
    assert.ok(names2.includes("Charlie Ford"));
  });
});
