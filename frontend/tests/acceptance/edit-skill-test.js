import { module, test } from "qunit";
import page from "frontend/tests/pages/skills-index";
import setupApplicationTest from "frontend/tests/helpers/setup-application-test";
import { currentURL } from "@ember/test-helpers";
import { selectChoose } from "ember-power-select/test-support";
import keycloakStub from "../helpers/keycloak-stub";

const nonAdminKeycloakStub = keycloakStub.extend({
  hasResourceRole(resource, role) {
    return false;
  }
});

module("Acceptance | edit skill", function(hooks) {
  setupApplicationTest(hooks);

  test("edits Rails to Travis CI", async function(assert) {
    assert.expect(7);

    await page.indexPage.visit();

    assert.equal(currentURL(), "/skills");

    assert.equal(page.indexPage.skills.skillNames.toArray()[4].text, "Rails");
    await page.indexPage.skills.skillEditButtons.toArray()[4].clickOn();

    await page.indexPage.skillEdit.skillName("Travis CI");
    await page.indexPage.skillEdit.skillDefaultSet();
    /* eslint "no-undef": "off" */
    await selectChoose(".skill-edit-parent-category", "System-Engineering");
    await selectChoose(".skill-edit-child-category", "Linux-Engineering");
    await selectChoose(".skill-edit-radar", "assess");
    await selectChoose(".skill-edit-portfolio", "aktiv");
    await page.indexPage.skillEdit.save();

    let rows = page.indexPage.skills.skillRow.toArray()[5].text;
    assert.ok(rows.includes("Travis CI"));
    assert.ok(rows.includes("System-Engineering"));
    assert.ok(rows.includes("Linux-Engineering"));
    assert.ok(rows.includes("assess"));
    assert.ok(rows.includes("aktiv"));
  });
  test("can non admin user visit skills", async function(assert) {
    assert.expect(1);
    this.owner.register("service:keycloak-session", nonAdminKeycloakStub);
    await page.indexPage.visit();
    assert.equal(currentURL(), "/skills");
  });
});
