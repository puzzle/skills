import { module, test } from "qunit";
import page from "frontend/tests/pages/skills-index";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { currentURL, triggerEvent } from "@ember/test-helpers";
import { selectChoose } from "ember-power-select/test-support";

module("Acceptance | filter skills", function(hooks) {
  setupApplicationTest(hooks);

  test("filters nothing and shows every skill", async function(assert) {
    assert.expect(4);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skills");

    let names = page.indexPage.skills.skillNames
      .toArray()
      .map(name => name.text);
    assert.ok(names.includes("JUnit"));
    assert.ok(names.includes("• Bash"));
    assert.ok(names.includes("Rails") || names.includes("Travis CI"));
  });

  test("filters only defaultSet by default", async function(assert) {
    assert.expect(5);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skills");

    await page.indexPage.defaultFilterButton();

    assert.equal(currentURL(), "/skills?defaultSet=true");
    let names = page.indexPage.skills.skillNames
      .toArray()
      .map(name => name.text);
    assert.notOk(names.includes("JUnit"));
    assert.notOk(names.includes("Bash"));
    assert.ok(names.includes("Rails"));
  });

  test("filters only defaultSet by new", async function(assert) {
    assert.expect(5);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skills");

    await page.indexPage.newFilterButton();

    assert.equal(currentURL(), "/skills?defaultSet=new");
    let names = page.indexPage.skills.skillNames
      .toArray()
      .map(name => name.text);
    assert.notOk(names.includes("JUnit"));
    assert.notOk(names.includes("Rails"));
    assert.ok(names.includes("• Bash"));
  });

  test("filters only category by System-Engineering", async function(assert) {
    assert.expect(5);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skills");

    let store = this.owner.__container__.lookup("service:store");
    let allCategories = store.peekAll("category");
    await allCategories;
    let filterCategory = allCategories.filterBy(
      "title",
      "System-Engineering"
    )[0];
    /* eslint "no-undef": "off" */
    await selectChoose(
      "#category-filter-dropdown",
      filterCategory.get("title")
    );

    assert.equal(currentURL(), "/skills?category=" + filterCategory.get("id"));

    let names = page.indexPage.skills.skillNames
      .toArray()
      .map(name => name.text);

    assert.notOk(names.includes("JUnit"));
    assert.notOk(names.includes("Rails"));
    assert.ok(names.includes("• Bash"));
  });

  test("filters skills by title like a", async function(assert) {
    assert.expect(5);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skills");

    await page.indexPage.skillsetSearchfield("a");
    await triggerEvent("input", "keyup");

    assert.equal(currentURL(), "/skills?title=a");
    const names = page.indexPage.skills.skillNames
      .toArray()
      .map(name => name.text);
    assert.notOk(names.includes("JUnit"));
    assert.ok(names.includes("• Bash"));
    assert.ok(names.includes("Rails"));
  });

  test("filters category by Software-Engineering and defaultSet by true", async function(assert) {
    assert.expect(6);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skills");

    let store = this.owner.__container__.lookup("service:store");
    let allCategories = store.peekAll("category");
    await allCategories;
    let filterCategory = allCategories.filterBy(
      "title",
      "Software-Engineering"
    )[0];

    /* eslint "no-undef": "off" */
    await selectChoose(
      "#category-filter-dropdown",
      filterCategory.get("title")
    );

    assert.equal(currentURL(), "/skills?category=" + filterCategory.get("id"));

    await page.indexPage.defaultFilterButton();

    assert.equal(
      currentURL(),
      "/skills?category=" + filterCategory.get("id") + "&defaultSet=true"
    );

    let names = page.indexPage.skills.skillNames
      .toArray()
      .map(name => name.text);

    assert.notOk(names.includes("JUnit"));
    assert.notOk(names.includes("Bash"));
    assert.ok(names.includes("Rails"));
  });

  test("filters category by Software-Engineering, defaultSet by false and title like a", async function(assert) {
    assert.expect(7);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skills");

    let store = this.owner.__container__.lookup("service:store");
    let allCategories = store.peekAll("category");
    await allCategories;
    let filterCategory = allCategories.filterBy(
      "title",
      "Software-Engineering"
    )[0];

    /* eslint "no-undef": "off" */
    await selectChoose(
      "#category-filter-dropdown",
      filterCategory.get("title")
    );

    assert.equal(currentURL(), "/skills?category=" + filterCategory.get("id"));

    await page.indexPage.allFilterButton();

    assert.equal(
      currentURL(),
      "/skills?category=" + filterCategory.get("id") + "&defaultSet="
    );

    await page.indexPage.skillsetSearchfield("Rails");
    await triggerEvent("input", "keyup");

    assert.equal(
      currentURL(),
      "/skills?category=" +
        filterCategory.get("id") +
        "&defaultSet=&title=Rails"
    );

    let names = page.indexPage.skills.skillNames
      .toArray()
      .map(name => name.text);

    assert.notOk(names.includes("JUnit"));
    assert.notOk(names.includes("Bash"));
    assert.ok(names.includes("Rails"));
  });
});
