import { module, test } from "qunit";
import applicationPage from "frontend/tests/pages/application";
import page from "frontend/tests/pages/person-skills";
import skillSearchPage from "frontend/tests/pages/skill-search";
import personPage from "frontend/tests/pages/person-edit";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";

module("Acceptance | redirect to last profile", function(hooks) {
  setupApplicationTest(hooks);

  test("redirect to last visited cv page", async function(assert) {
    assert.expect(3);

    // Go to the start page and select a user from the dropdown
    await applicationPage.visitHome("/");
    /* eslint "no-undef": "off" */
    await selectChoose("#people-search", ".ember-power-select-option", 0);

    const person_id = /\d+$/.exec(currentURL());

    assert.equal(currentURL(), "/people/" + person_id);

    await skillSearchPage.indexPage.visit();

    assert.equal(currentURL(), "/skill_search");

    await applicationPage.profileMenuItem();

    assert.equal(currentURL(), "/people/" + person_id);
  });

  test("redirect to last skill page", async function(assert) {
    assert.expect(3);

    // Go to the start page and select a user from the dropdown
    await applicationPage.visitHome("/");
    await selectChoose("#people-search", ".ember-power-select-option", 0);

    const person_id = /\d+$/.exec(currentURL());

    await page.visit({ person_id: /\d+$/.exec(currentURL()) });

    assert.equal(currentURL(), "/people/" + person_id + "/skills");

    await skillSearchPage.indexPage.visit();

    assert.equal(currentURL(), "/skill_search");

    await applicationPage.profileMenuItem();

    assert.equal(currentURL(), "/people/" + person_id + "/skills");
  });

  test("redirect to last skill page using same rated filter", async function(assert) {
    assert.expect(3);

    // Go to the start page and select a user from the dropdown
    await applicationPage.visitHome("/");
    await selectChoose("#people-search", ".ember-power-select-option", 0);

    const person_id = /\d+$/.exec(currentURL());

    await page.visit({ person_id: /\d+$/.exec(currentURL()) });

    await page.filterButtons.rated();

    assert.equal(
      currentURL(),
      "/people/" + person_id + "/skills?personId=" + person_id + "&rated=true"
    );

    await skillSearchPage.indexPage.visit();

    assert.equal(currentURL(), "/skill_search");

    await applicationPage.profileMenuItem();

    assert.equal(
      currentURL(),
      "/people/" + person_id + "/skills?personId=" + person_id + "&rated=true"
    );
  });

  test("do not redirect after visiting only people page", async function(assert) {
    assert.expect(4);

    // Go to the start page and select a user from the dropdown
    await applicationPage.visitHome("/");
    /* eslint "no-undef": "off" */
    await selectChoose("#people-search", ".ember-power-select-option", 0);

    const person_id = /\d+$/.exec(currentURL());

    assert.equal(currentURL(), "/people/" + person_id);

    await applicationPage.profileMenuItem();

    assert.equal(currentURL(), "/people");

    await skillSearchPage.indexPage.visit();

    assert.equal(currentURL(), "/skill_search");

    await applicationPage.profileMenuItem();

    assert.equal(currentURL(), "/people");
  });

  test("redirects correctly after switching between subroutes", async function(assert) {
    assert.expect(5);

    // Go to the start page and select a user from the dropdown
    await applicationPage.visitHome("/");
    /* eslint "no-undef": "off" */
    await selectChoose("#people-search", ".ember-power-select-option", 0);

    const person_id = /\d+$/.exec(currentURL());

    assert.equal(currentURL(), "/people/" + person_id);

    await page.visit({ person_id: /\d+$/.exec(currentURL()) });

    assert.equal(currentURL(), "/people/" + person_id + "/skills");

    await personPage.visit({ person_id });

    assert.equal(currentURL(), "/people/" + person_id);

    await skillSearchPage.indexPage.visit();

    assert.equal(currentURL(), "/skill_search");

    await applicationPage.profileMenuItem();

    assert.equal(currentURL(), "/people/" + person_id);
  });
});
