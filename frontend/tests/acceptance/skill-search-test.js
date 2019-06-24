import { test } from "qunit";
import moduleForAcceptance from "frontend/tests/helpers/module-for-acceptance";
import { authenticateSession } from "frontend/tests/helpers/ember-simple-auth";
import page from "frontend/tests/pages/skill-search";

moduleForAcceptance("Acceptance | skill search", {
  beforeEach() {
    authenticateSession(this.application, {
      ldap_uid: "development_user",
      token: "1234"
    });
  }
});

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
  assert.equal(currentURL(), "/skill_search?skill_id=" + rails.get("id"));
  const names = page.indexPage.peopleSkills.peopleNames
    .toArray()
    .map(name => name.text);
  assert.notOk(names.includes("ken"));
  assert.notOk(names.includes("Alice Mante"));
  assert.ok(names.includes("Bob Anderson"));
});

test("search peopleSkills of JUnit", async function(assert) {
  assert.expect(5);

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
  assert.equal(currentURL(), "/skill_search?skill_id=" + junit.get("id"));
  const names = page.indexPage.peopleSkills.peopleNames
    .toArray()
    .map(name => name.text);
  assert.notOk(names.includes("ken"));
  assert.ok(names.includes("Alice Mante"));
  assert.notOk(names.includes("Bob Anderson"));
});
