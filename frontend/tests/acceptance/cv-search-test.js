import { module, test } from "qunit";
import page from "frontend/tests/pages/cv-search";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { currentURL, triggerEvent } from "@ember/test-helpers";
import { setupIntl, t } from "ember-intl/test-support";

module("Acceptance | cv search", function(hooks) {
  setupApplicationTest(hooks);
  setupIntl(hooks);

  test("search person by title MA in sending silly memes", async function(assert) {
    assert.expect(6);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("MA in sending silly memes");
    await triggerEvent("input", "keyup");
    assert.equal(
      currentURL(),
      "/cv_search?q=MA%20in%20sending%20silly%20memes"
    );
    const names = page.indexPage.people.peopleNames
      .toArray()
      .map(name => name.text);
    const foundIns = page.indexPage.people.peopleFoundInLink
      .toArray()
      .map(foundIn => foundIn.text);
    assert.ok(names.includes("ken"));
    assert.ok(foundIns.includes(t("person.title")));
    assert.notOk(names.includes("Alice Mante"));
    assert.notOk(names.includes("Bob Anderson"));
  });

  test("search person by competence and project technology Java", async function(assert) {
    assert.expect(7);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("Java");
    await triggerEvent("input", "keyup");

    assert.equal(currentURL(), "/cv_search?q=Java");
    const names = page.indexPage.people.peopleNames
      .toArray()
      .map(name => name.text);
    const foundIn = page.indexPage.people.peopleFoundInLink
      .toArray()
      .map(foundIn => foundIn.text);
    assert.ok(names.includes("Bob Anderson"));
    assert.ok(names.includes("Alice Mante"));
    assert.ok(foundIn.includes(t("person.projects")));
    assert.ok(foundIn.includes(t("person.personCompetences")));
    assert.notOk(names.includes("ken"));
  });

  test("search person by activity description Ascom", async function(assert) {
    assert.expect(6);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("Ascom");
    await triggerEvent("input", "keyup");

    assert.equal(currentURL(), "/cv_search?q=Ascom");
    const names = page.indexPage.people.peopleNames
      .toArray()
      .map(name => name.text);
    const foundIn = page.indexPage.people.peopleFoundInLink
      .toArray()
      .map(foundIn => foundIn.text);
    assert.ok(names.includes("Alice Mante"));
    assert.ok(foundIn.includes(t("person.activities")));
    assert.notOk(names.includes("Bob Anderson"));
    assert.notOk(names.includes("ken"));
  });

  test("search person by education location Uni Bern", async function(assert) {
    assert.expect(6);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("Uni Bern");
    await triggerEvent("input", "keyup");

    assert.equal(currentURL(), "/cv_search?q=Uni%20Bern");
    const names = page.indexPage.people.peopleNames
      .toArray()
      .map(name => name.text);
    const foundIn = page.indexPage.people.peopleFoundInLink
      .toArray()
      .map(foundIn => foundIn.text);
    assert.ok(names.includes("Bob Anderson"));
    assert.ok(foundIn.includes(t("person.educations")));
    assert.notOk(names.includes("Alice Mante"));
    assert.notOk(names.includes("ken"));
  });

  test("search person by advanced_training description was nice", async function(assert) {
    assert.expect(6);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("was nice");
    await triggerEvent("input", "keyup");

    assert.equal(currentURL(), "/cv_search?q=was%20nice");
    const names = page.indexPage.people.peopleNames
      .toArray()
      .map(name => name.text);
    const foundIn = page.indexPage.people.peopleFoundInLink
      .toArray()
      .map(foundIn => foundIn.text);
    assert.ok(names.includes("Alice Mante"));
    assert.ok(foundIn.includes(t("person.advancedTrainings")));
    assert.notOk(names.includes("Bob Anderson"));
    assert.notOk(names.includes("ken"));
  });
});
