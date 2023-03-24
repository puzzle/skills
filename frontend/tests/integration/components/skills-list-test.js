import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";
import { render } from "@ember/test-helpers";
import hbs from "htmlbars-inline-precompile";
import Service from "@ember/service";
import keycloakStub from "../../helpers/keycloak-stub";
import { setLocale, setupIntl } from "ember-intl/test-support";

const storeStub = Service.extend({
  createRecord(model) {
    return null;
  },

  query(type, options) {
    return Promise.all([
      "Software Engineering",
      "Beratung",
      "System Engineer",
      "Delivery"
    ]);
  },

  findAll(model, options) {
    return Promise.all([
      {
        title: "Software Engineering",
        get() {
          return null;
        }
      },
      {
        title: "UX Tools",
        get() {
          return { title: "UX Design" };
        }
      },
      {
        title: "System Engineer",
        get() {
          return null;
        }
      },
      {
        title: "Diverses",
        get() {
          return { title: "Keine Kategorie" };
        }
      }
    ]);
  }
});

const nonAdminKeycloakStub = keycloakStub.extend({
  hasResourceRole(resource, role) {
    return false;
  }
});

module("Integration | Component | skills-list", function(hooks) {
  /* eslint-disable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */

  setupRenderingTest(hooks);
  setupIntl(hooks);

  hooks.beforeEach(function(assert) {
    setLocale("de");

    this.owner.register("service:store", storeStub);
    this.owner.register("service:keycloak-session", keycloakStub);
  });

  test("it renders without data", async function(assert) {
    await render(hbs`{{skills-list}}`);

    assert.dom(".edit-buttons", document).includesText("Export");
    assert.dom("#new-skill-link", document).includesText("Neuer Skill");
    assert.dom("#defaultFilterAll", document).includesText("Alle");
    assert.dom("#defaultFilterNew", document).includesText("Neue");
  });

  test("it renders for non admin user", async function(assert) {
    this.owner.register("service:keycloak-session", nonAdminKeycloakStub);
    await render(hbs`{{skills-list}}`);

    assert.dom(".edit-buttons", document).includesText("Export");
    assert.dom("#new-skill-link", document).includesText("Neuer Skill");
  });

  test("it displays grayed out create skill text", async function(assert) {
    this.owner.register("service:keycloak-session", nonAdminKeycloakStub);
    await render(hbs`{{skills-list}}`);

    assert.equal(
      document.querySelector("#new-skill-link").className,
      "edit-buttons grayed-out"
    );
  });

  test("it renders with data", async function(assert) {
    this.set("skills", [
      {
        get() {
          return { title: "Ruby" };
        },
        title: "Ruby",
        portfolio: "aktiv",
        radar: "assess",
        category: {
          title: "Software-Engineering"
        },
        people: ["person1", "person2"]
      },
      {
        get() {
          return { title: "Jenkins" };
        },
        title: "Jenkins",
        portfolio: "passiv",
        radar: "assess",
        category: {
          title: "CI/CD"
        },
        people: ["person1"]
      }
    ]);

    await render(hbs`{{skills-list skills=skills}}`);

    let text = document.querySelector(".mt-5").textContent;

    assert.ok(text.includes("Ruby"));
    assert.ok(text.includes("aktiv"));
    assert.ok(text.includes("assess"));
    assert.ok(text.includes("Software-Engineering"));
    assert.ok(text.includes("2"));
    assert.ok(text.includes("Jenkins"));
    assert.ok(text.includes("passiv"));
    assert.ok(text.includes("assess"));
    assert.ok(text.includes("CI/CD"));
    assert.ok(text.includes("1"));
  });

  /* eslint-enable ember/no-global-jquery, no-undef, ember/jquery-ember-run  */
});
