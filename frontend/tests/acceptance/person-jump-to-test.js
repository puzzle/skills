import { module, test } from "qunit";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { click, currentURL, triggerEvent } from "@ember/test-helpers";
import page from "frontend/tests/pages/cv-search";

module("Acceptance | person jump to", function(hooks) {
  setupApplicationTest(hooks);

  test("jump to Bachelor of Communications", async function(assert) {
    assert.expect(3);

    await page.indexPage.visit();
    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("Bachelor of Communications");
    await triggerEvent("input", "keyup");
    assert.equal(currentURL(), "/cv_search?q=Bachelor%20of%20Communications");

    await click(".cv-search-found-in-link");
    assert.equal(
      currentURL(),
      "/people/9?query=Bachelor%20of%20Communications"
    );
  });

  test("jump to Gregor", async function(assert) {
    assert.expect(3);

    await page.indexPage.visit();
    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("Gregor");
    await triggerEvent("input", "keyup");
    assert.equal(currentURL(), "/cv_search?q=Gregor");

    await click(".cv-search-found-in-link");
    assert.equal(currentURL(), "/people/6?query=Gregor");
  });

  test("jump to agriculturist", async function(assert) {
    assert.expect(3);

    await page.indexPage.visit();
    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("agriculturist");
    await triggerEvent("input", "keyup");
    assert.equal(currentURL(), "/cv_search?q=agriculturist");

    await click(".cv-search-found-in-link");
    assert.equal(currentURL(), "/people/3?query=agriculturist");
  });

  test("jump to judge", async function(assert) {
    assert.expect(3);

    await page.indexPage.visit();
    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("judge");
    await triggerEvent("input", "keyup");
    assert.equal(currentURL(), "/cv_search?q=judge");

    await click(".cv-search-found-in-link");
    assert.equal(currentURL(), "/people/5?query=judge");
  });

  test("jump to Vitakinesis", async function(assert) {
    assert.expect(3);

    await page.indexPage.visit();
    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("Vitakinesis");
    await triggerEvent("input", "keyup");
    assert.equal(currentURL(), "/cv_search?q=Vitakinesis");

    await click(".cv-search-found-in-link");
    assert.equal(currentURL(), "/people/12?query=Vitakinesis");
  });
});
