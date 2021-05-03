import { module, test } from "qunit";
import page from "frontend/tests/pages/cv-search";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { click, currentURL, triggerEvent } from "@ember/test-helpers";

module("Acceptance | person jump to", function(hooks) {
  setupApplicationTest(hooks);

  test("jump to BSc in Cleaning", async function(assert) {
    assert.expect(5);

    await page.indexPage.visit();
    assert.equal(currentURL(), "/cv_search");

    await page.indexPage.searchInput("BSc in Cleaning");
    await triggerEvent("input", "keyup");
    assert.equal(currentURL(), "/cv_search?q=BSc%20in%20Cleaning");

    const names = page.indexPage.people.peopleNames
      .toArray()
      .map(name => name.text);
    const foundIns = page.indexPage.people.peopleFoundInLink
      .toArray()
      .map(foundIn => foundIn.text);
    assert.ok(names.includes("Bob Anderson"));
    assert.ok(foundIns.includes("Titel"));

    const button = document.querySelector(".cv-search-found-in-link");
    await click(button);

    let store = this.owner.__container__.lookup("service:store");
    let bob = store
      .peekAll("person")
      .filter(person => person.get("name") == "Bob Anderson")
      .get("firstObject");
    await bob;

    assert.equal(
      currentURL(),
      "/people/" + bob.get("id") + "?query=BSc%20in%20Cleaning"
    );
  });
});
