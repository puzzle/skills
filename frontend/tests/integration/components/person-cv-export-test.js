import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import keycloakStub from "../../helpers/keycloak-stub";
import page from "frontend/tests/pages/person-cv-export";

const nonAdminKeycloakStub = keycloakStub.extend({
  hasResourceRole(resource, role) {
    return false;
  }
});

module("Integration | Component | person-cv-export", function(hooks) {
  setupRenderingTest(hooks);

  test("it renders export pop up", async function(assert) {
    this.owner.register("service:keycloak-session", nonAdminKeycloakStub);

    await render(hbs`{{person-cv-export}}`);

    assert.ok(this.element.textContent.trim().includes("CV-Export"));
    assert.ok(
      this.element.textContent
        .trim()
        .includes("person-cv-export.locationForFooter")
    );
    assert.ok(
      this.element.textContent
        .trim()
        .includes("person-cv-export.coreCompetenciesSkills")
    );
    assert.ok(
      this.element.textContent.trim().includes("person-cv-export.levelSkills")
    );
    assert.ok(
      this.element.textContent.trim().includes("person-cv-export.normalCV")
    );
    assert.ok(
      this.element.textContent.trim().includes("person-cv-export.anonymisedCV")
    );
    assert.ok(
      this.element.textContent.trim().includes("person-cv-export.cancel")
    );
    assert.equal(this.$("button").length, 4);
  });

  test("it sets skill level with ui slider", async function(assert) {
    this.owner.register("service:keycloak-session", nonAdminKeycloakStub);

    await render(hbs`{{person-cv-export}}`);

    let toggle = this.element.querySelector("#levelSkillsToggle");
    toggle.click();

    assert.ok(this.element.textContent.trim().includes("Trainee"));
    await page.personSkillSlider.levelButtons.objectAt(3).click();
    assert.ok(this.element.textContent.trim().includes("Expert"));
  });

  test("it generates right url", async function(assert) {
    this.owner.register("service:keycloak-session", nonAdminKeycloakStub);

    await render(hbs`{{person-cv-export}}`);

    this.levelValue = 2;
    this.$("button")[2].click();
    assert.equal(downloadServiceSpy.toHaveBeenCalled(), true);
  });
});
