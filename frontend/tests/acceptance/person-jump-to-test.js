import { module, test } from "qunit";
import page from "frontend/tests/pages/cv-search";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { currentURL, triggerEvent } from "@ember/test-helpers";

module("Acceptance | person jump to", function(hooks) {
  setupApplicationTest(hooks);

  test("jump to Bachelor of Communications", async function(assert) {
    //assert.expect(3);

    await page.indexPage.visit();
    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("Bachelor of Communications");
    await triggerEvent("input", "keyup");
    assert.equal(currentURL(), "/cv_search?q=Bachelor%20of%20Communications");

    let store = this.owner.__container__.lookup("service:store");
    let jorah = store
      .peekAll("person")
      .filter(person => person.get("name") == "Jorah Mormont")
      .get("firstObject");
    await jorah;

    //await click(".cv-search-found-in-link");

    assert.equal(
      currentURL(),
      "/people/" + jorah.get("id") + "?query=Bachelor%20of%20Communications"
    );
  });

  /*
  test("jump to Gregor", async function(assert) {
    assert.expect(3);

    await page.indexPage.visit();
    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("Gregor");
    await triggerEvent("input", "keyup");
    assert.equal(currentURL(), "/cv_search?q=Gregor");

    await click(".cv-search-found-in-link");

    let store = this.owner.__container__.lookup("service:store");
    let junit = store
      .peekAll("skill")
      .filter(skill => skill.get("title") == "JUnit")
      .get("firstObject");
    await junit;
    assert.equal(currentURL(), "/people/" + junit.get("id") + "?query=Gregor");
  });

  test("jump to agriculturist", async function(assert) {
    assert.expect(3);

    await page.indexPage.visit();
    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("agriculturist");
    await triggerEvent("input", "keyup");
    assert.equal(currentURL(), "/cv_search?q=agriculturist");

    await click(".cv-search-found-in-link");

    let store = this.owner.__container__.lookup("service:store");
    let junit = store
      .peekAll("skill")
      .filter(skill => skill.get("title") == "JUnit")
      .get("firstObject");
    await junit;
    assert.equal(
      currentURL(),
      "/people/" + junit.get("id") + "?query=agriculturist"
    );
  });

  test("jump to judge", async function(assert) {
    assert.expect(3);

    await page.indexPage.visit();
    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("judge");
    await triggerEvent("input", "keyup");
    assert.equal(currentURL(), "/cv_search?q=judge");

    await click(".cv-search-found-in-link");

    let store = this.owner.__container__.lookup("service:store");
    let junit = store
      .peekAll("skill")
      .filter(skill => skill.get("title") == "JUnit")
      .get("firstObject");
    await junit;
    assert.equal(currentURL(), "/people/" + junit.get("id") + "?query=judge");
  });

  test("jump to Vitakinesis", async function(assert) {
    //assert.expect(3);

    await page.indexPage.visit();
    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("Vitakinesis");
    await triggerEvent("input", "keyup");
    assert.equal(currentURL(), "/cv_search?q=Vitakinesis");

    await click(".cv-search-found-in-link");

    let store = this.owner.__container__.lookup("service:store");
    let junit = store
      .peekAll("skill")
      .filter(skill => skill.get("title") == "JUnit")
      .get("firstObject");
    await junit;

    assert.equal(
      currentURL(),
      "/people/" + junit.get("id") + "?query=Vitakinesis"
    );
  });
  */
});
