import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import keycloakStub from "../../helpers/keycloak-stub";

module("Integration | Component | skills-list-row-show", function(hooks) {
  setupRenderingTest(hooks);

  const nonAdminKeycloakStub = keycloakStub.extend({
    hasResourceRole(resource, role) {
      return false;
    }
  });

  test("it renders", async function(assert) {
    this.owner.register("service:keycloak-session", nonAdminKeycloakStub);

    this.set("skill", {
      title: "Ruby",
      portfolio: "aktiv",
      radar: "assess",
      category: {
        title: "Software-Engineering"
      },
      people: ["person1", "person2"]
    });

    await render(hbs`{{skills-list-row-show skill=skill}}`);

    assert.ok(this.element.textContent.trim().includes("2"));
    assert.ok(this.element.textContent.trim().includes("Software-Engineering"));
    assert.ok(this.element.textContent.trim().includes("assess"));
    assert.ok(this.element.textContent.trim().includes("aktiv"));
  });

  test("it displays grayed out edit icon", async function(assert) {
    this.owner.register("service:keycloak-session", nonAdminKeycloakStub);
    await render(hbs`{{skills-list-row-show}}`);

    assert.equal(
      this.element.querySelector("a").getAttribute("class"),
      "edit-buttons skill-edit-button grayed-out"
    );
  });
});
