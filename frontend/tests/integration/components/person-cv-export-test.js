import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import keycloakStub from "../../helpers/keycloak-stub";
import page from "frontend/tests/pages/person-cv-export";
import $ from "jquery";
import Service from "@ember/service";

const nonAdminKeycloakStub = keycloakStub.extend({
  hasResourceRole(resource, role) {
    return false;
  }
});

class MockDownloadService extends Service {
  file(url) {
    return "api/person";
  }
}

module("Integration | Component | person-cv-export", function(hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function() {
    this.owner.register("service:download", MockDownloadService);
  });

  test("it renders export pop up", async function(assert) {
    /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */

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
    assert.equal($("button").length, 4);

    /* eslint-enable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
  });

  test("it sets skill level with ui slider", async function(assert) {
    this.owner.register("service:keycloak-session", nonAdminKeycloakStub);

    await render(hbs`{{person-cv-export}}`);

    assert.ok(
      $(".person-skill-level")
        .attr("class")
        .includes("hidden")
    );

    let toggle = this.element.querySelector("#levelSkillsToggle");
    toggle.click();

    assert.ok(this.element.textContent.trim().includes("Trainee"));
    await page.personSkillSlider.levelButtons.objectAt(3).click();
    assert.ok(this.element.textContent.trim().includes("Expert"));
  });
});
