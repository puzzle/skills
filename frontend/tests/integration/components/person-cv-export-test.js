import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import keycloakStub from "../../helpers/keycloak-stub";
import Service from "@ember/service";
import page from "frontend/tests/pages/person-cv-export";
import downloadService from "../../../app/services/download";
import { jest } from "@jest/globals";

const nonAdminKeycloakStub = keycloakStub.extend({
  hasResourceRole(resource, role) {
    return false;
  }
});

let mockDownloadSerice = Service.extend({
  file(url) {
    return url;
  }
});
export let downloads;
export function setup(context) {
  context.application.register("service:mockDownloads", mockDownloadSerice);
  context.application.inject("component", "downloads", "service:mockDownloads");
  downloads = {
    file:
      "/api/people/16.odt?anon=false&location=1&includeCS=true&skillsByInterests=true&levelValue=2"
  };
}

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

    await page.personSkillSlider.levelButtons.objectAt(3).click();
    assert.equal(this.levelValue, 2);
  });

  test("it generates right url", async function(assert) {
    this.owner.register("service:keycloak-session", nonAdminKeycloakStub);

    await render(hbs`{{person-cv-export}}`);

    let downloadServiceSpy = jest.spyOn(
      downloadService.file,
      "downloadService"
    );

    this.levelValue = 2;
    this.$("button")[2].click();
    assert.equal(downloadServiceSpy.toHaveBeenCalled(), true);
  });
});
